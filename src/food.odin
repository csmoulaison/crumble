// TODO factor state machine logic out of here and into return statements

package main
import "core:fmt"
import "core:math/rand"
import "core:math/linalg"
import "core:math"

MAX_WINDOWS :: 8
MAX_FOODS_EATEN :: 256
MAX_CHOOSE_WINDOW_ITERATIONS :: 64
SCOREPOP_OFFSET :: Vec2{20, -12}

FoodPhase :: enum {
	INACTIVE,
	COOKING,
	COOKED,
	COOLING,
	POT,
	RESET,
}

Window :: struct {
	position: Vec2,
	is_active: bool, // redundant?
}

Food :: struct {
	phase: FoodPhase,
	time_to_next_phase: f32,
	time_to_blink_toggle: f32,
	is_blinking: bool,
	windows: [MAX_WINDOWS]Window,
	windows_len: int,
	active_windows: [MAX_WINDOWS]int,
	active_windows_len: int,
	current_window: int,
	current_food_offset: int,
    eaten_food_offsets: [MAX_FOODS_EATEN]int,
	// TODO this can be extrapolated from foods_eaten, yeah?
	level_complete: bool,
	animator: Animator,
}

init_food :: proc(food: ^Food, data: ^LevelData, config: ^FoodConfig) {
	using food

	windows_len = 0
	active_windows_len = 0
	for &window_pos in data.window_positions[:data.window_positions_len] {
		active_windows[windows_len] = windows_len

		windows_len += 1
		window := &windows[windows_len - 1]
		using window
		
		position = window_pos
		is_active = true
	}
	if windows_len < 1 {
		windows_len += 1
		windows[windows_len - 1].position = {0, 0}
	}

	active_windows_len = windows_len

	start_food_cycle(food, config)
	time_to_blink_toggle = 0
	level_complete = false

	choose_next_window(food)
}

draw_food :: proc(food: ^Food, platform: ^Platform) {
	using food 

	for window, index in windows[:windows_len] {
		if phase == FoodPhase.RESET do draw_window(is_blinking, window.position, platform)
		else do draw_window(window.is_active, window.position, platform)

		if index == current_window {
			food_src_pos := IVec2{1068, 18}
			cooked_src_pos := IVec2{592 + current_food_offset, 0}

			cooked_food := false

			#partial switch phase {
			case FoodPhase.COOKING:
				food_src_pos = {448, 0}
			case FoodPhase.COOKED:
				cooked_food = true
			case FoodPhase.COOLING:
				if !is_blinking {
					cooked_food = true
				}
			case FoodPhase.POT:
				food_src_pos = {288, 0}
			}

			food_draw_position := ivec2_from_vec2(window.position)
			if cooked_food {
				food_src_pos = cooked_src_pos
				food_draw_position.y += int(math.sin_f32(time_to_next_phase * 6) * 3) - 2
			}

			buffer_sprite(
				platform,
				IRect{food_src_pos, {16, 16}},
				food_draw_position,
				IVec2{8, 16},
				false)
		}
	}
}

draw_window :: proc(is_active: bool, position: Vec2, platform: ^Platform) {
	src_x := 448
	if !is_active do src_x = 464
	buffer_sprite(
		platform,
		IRect{{src_x, 16}, {16, 21}},
		ivec2_from_vec2(position),
		IVec2{8, 31},
		false)
}

update_food_state :: proc(food: ^Food, config: ^FoodConfig, sound_system: ^SoundSystem, dt: f32) {
	using food

	time_to_next_phase -= dt

	#partial switch phase {
	case FoodPhase.INACTIVE:
		if time_to_next_phase < 0 {
			phase, time_to_next_phase = FoodPhase.COOKING, config.cook_length
			if active_windows_len <= 1 {
				phase, time_to_next_phase = FoodPhase.POT, config.pot_expiration_length
			}

			start_sound(&sound_system.channels[0], SoundType.FOOD_COOKING)
		}
	case FoodPhase.COOKING:
		windows[current_window].is_active = int(time_to_next_phase * 4) % 2 == 0

		if time_to_next_phase < 0 {
			phase, time_to_next_phase = FoodPhase.COOKED, config.expiration_length
			current_food_offset = 128 * rand.int_max(4)
			start_sound(&sound_system.channels[0], SoundType.FOOD_APPEAR)
		}
	case FoodPhase.COOKED:
		// TODO: refactor this into function (also used in RESET phase)
		// should return whether it has just blinked for sounds and stuff
		// also won't have the / 2 part REMEMBER THE GLITCH!
		if time_to_next_phase < config.expiration_length / 2 {
			phase = FoodPhase.COOLING
		}
	case FoodPhase.COOLING:
		if time_to_next_phase < 0 {
			start_food_cycle(food, config)
			start_sound(&sound_system.channels[0], SoundType.FOOD_DISAPPEAR)
			break
		}

		time_to_blink_toggle -= dt
		if time_to_blink_toggle < 0 {
			is_blinking = !is_blinking
			time_to_blink_toggle = config.blink_length
			start_sound(&sound_system.channels[0], SoundType.FOOD_BLINK)
		}
	case FoodPhase.POT:
		if time_to_next_phase < 0 {
			phase, time_to_next_phase = FoodPhase.COOKED, config.expiration_length
			break
		}
	}
}

update_food_eating :: proc(food: ^Food, king: ^King, session: ^Session, sound_system: ^SoundSystem, config: ^FoodConfig) {
	if !(food.phase == FoodPhase.COOKED || food.phase == FoodPhase.COOLING) {
		return 
	}

	if linalg.distance(food.windows[food.current_window].position, king.position) < config.distance_to_eat {
        food.eaten_food_offsets[int(king.foods_eaten)] = food.current_food_offset

		king.foods_eaten += 1
		if food.phase == FoodPhase.COOKED {
			session.level_points += config.high_points
			pop_score(&session.scorepop, king.position + SCOREPOP_OFFSET, ScorepopType.BIG)
		} else {
			session.level_points += config.low_points
			pop_score(&session.scorepop, king.position + SCOREPOP_OFFSET, ScorepopType.LITTLE)
		}

		for &active_window, i in food.active_windows[:food.active_windows_len] {
			if active_window == food.current_window {
				food.windows[food.current_window].is_active = false
				active_window = food.active_windows[food.active_windows_len - 1]
				food.active_windows_len -= 1
			}
		}

		if food.active_windows_len > 0 {
			start_food_cycle(food, config)
            start_sound(&sound_system.channels[0], SoundType.FOOD_EAT)
			session.state = SessionState.HITCH
			session.time_to_next_state = config.hitch_length
		} else {
			food.phase = FoodPhase.RESET
			session.state = SessionState.FOOD_RESET
			session.time_to_next_state = config.reset_length
			food.time_to_blink_toggle = 0
		}
	}
}

update_pot_bounce :: proc(food: ^Food, king: ^King, session: ^Session, sound_system: ^SoundSystem, config: ^LevelConfig) {
	using food
	if food.phase != FoodPhase.POT do return

	pot_pos_off := Vec2{-8, -8}
	pot_pos := windows[current_window].position + pot_pos_off
	pot_col := Rect{{2, 0}, {12, 4}}
	king_collider := Rect{{-5, -16}, {10, 16}}
	if is_colliding(&king_collider, &king.position, &pot_col, &pot_pos) && king.position.y > pot_pos.y - 6 && king.velocity.y > 0 {
		stop_music(sound_system)
		start_sound(&sound_system.channels[0], SoundType.POT_BOUNCE)
		pop_score(&session.scorepop, pot_pos + Vec2{26, -16}, ScorepopType.POT)
		session.level_points += 50

		session.state = SessionState.POST_WIN
		session.time_to_next_state = config.post_win_length
	}
}

start_food_cycle :: proc(food: ^Food, config: ^FoodConfig) {
	using food

	phase = FoodPhase.INACTIVE
	time_to_next_phase = config.inactive_length
	time_to_blink_toggle = 0
	is_blinking = false
	choose_next_window(food)
}

choose_next_window :: proc(food: ^Food) {
	using food 

	if active_windows_len <= 0 do current_window = rand.int_max(windows_len)
	else do current_window = active_windows[rand.int_max(active_windows_len)]
}