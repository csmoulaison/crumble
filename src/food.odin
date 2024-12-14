package main
import "core:fmt"
import "core:math/rand"
import "core:math/linalg"
import "core:math"

MAX_WINDOWS :: 8
MAX_FOODS_EATEN :: 256
MAX_CHOOSE_WINDOW_ITERATIONS :: 64
SCOREPOP_OFFSET :: Vec2{20, -12}
FOOD_SRC_OFFSET :: 128

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
	current_food_index: int,
    eaten_food_indices: [MAX_FOODS_EATEN]int,
    round: int,
	// TODO this can be extrapolated from foods_eaten, yeah?
	level_complete: bool,
	animator: Animator,
}

init_food :: proc(food: ^Food, data: ^LevelData, config: ^Config) {
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

	round = 0
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
			cooked_src_pos := IVec2{592 + current_food_index * FOOD_SRC_OFFSET, 0}

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

update_food_state :: proc(food: ^Food, config: ^Config, sound_system: ^SoundSystem, dt: f32) {
	using food

	time_to_next_phase -= dt

	#partial switch phase {
	case FoodPhase.INACTIVE:
		if time_to_next_phase < 0 {
			phase, time_to_next_phase = FoodPhase.COOKING, config.food_cook_length
            // TODO IF this is fucked for debug should be 1
			if active_windows_len <= 1 {
				phase, time_to_next_phase = FoodPhase.POT, config.food_pot_expiration_length
			}

			start_sound(sound_system, SoundType.FOOD_COOKING)
		}
	case FoodPhase.COOKING:
		windows[current_window].is_active = int(time_to_next_phase * 4) % 2 == 0

		if time_to_next_phase < 0 {
			phase, time_to_next_phase = FoodPhase.COOKED, config.food_expiration_length
			current_food_index = rand.int_max(4)
			start_sound(sound_system, SoundType.FOOD_APPEAR)
		}
	case FoodPhase.COOKED:
		// TODO: refactor this into function (also used in RESET phase)
		// should return whether it has just blinked for sounds and stuff
		// also won't have the / 2 part REMEMBER THE GLITCH!
		if time_to_next_phase < config.food_expiration_length / 2 {
			phase = FoodPhase.COOLING
		}
	case FoodPhase.COOLING:
		if time_to_next_phase < 0 {
			start_food_cycle(food, config)
			start_sound(sound_system, SoundType.FOOD_DISAPPEAR)
			break
		}

		time_to_blink_toggle -= dt
		if time_to_blink_toggle < 0 {
			is_blinking = !is_blinking
			time_to_blink_toggle = config.food_blink_length
			start_sound(sound_system, SoundType.FOOD_BLINK)
		}
	case FoodPhase.POT:
		if time_to_next_phase < 0 {
			phase, time_to_next_phase = FoodPhase.COOKED, config.food_expiration_length
			break
		}
	}
}

update_food_eating :: proc(food: ^Food, king: ^King, session: ^Session, sound_system: ^SoundSystem, config: ^Config) {
	if !(food.phase == FoodPhase.COOKED || food.phase == FoodPhase.COOLING) {
		return 
	}

	if linalg.distance(food.windows[food.current_window].position, king.position) < config.food_distance_to_eat {
        food.eaten_food_indices[int(king.foods_eaten)] = food.current_food_index

		king.foods_eaten += 1
		if food.phase == FoodPhase.COOKED {
			session.level_points += config.food_high_points
			pop_score(&session.scorepop, king.position + SCOREPOP_OFFSET, ScorepopType.BIG)
		} else {
			session.level_points += config.food_low_points
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
            start_sound(sound_system, SoundType.FOOD_EAT)
			session.state = SessionState.HITCH
			session.time_to_next_state = config.food_hitch_length
		} else {
			stop_music(sound_system)
			food.phase = FoodPhase.RESET
			session.state = SessionState.FOOD_RESET
			session.time_to_next_state = config.food_reset_length
			food.time_to_blink_toggle = 0
			food.round += 1
		}
	}
}

update_pot_bounce :: proc(food: ^Food, king: ^King, session: ^Session, sound_system: ^SoundSystem, config: ^Config) {
	using food
	if food.phase != FoodPhase.POT do return

	pot_pos_off := Vec2{-8, -8}
	pot_pos := windows[current_window].position + pot_pos_off
	pot_col := Rect{{2, 0}, {12, 4}}
	king_collider := Rect{{-5, -16}, {10, 16}}
	if is_colliding(&king_collider, &king.position, &pot_col, &pot_pos) && king.position.y > pot_pos.y - 6 && king.velocity.y > 0 {
		if session.current_level == 0 && king.foods_eaten == 4 {
			correct_code: bool = true
			code: [secret_code_len]int = code_food
			for i in 0..<4 {
				if code[i] != eaten_food_indices[i] {
					correct_code = false
					break
				}
			}

			if correct_code {
				session.food_hint_accomplished = true
			}
		}
		
		stop_music(sound_system)
		start_sound(sound_system, SoundType.POT_BOUNCE)
		pop_score(&session.scorepop, pot_pos + Vec2{26, -16}, ScorepopType.POT)
		session.level_points += 50

		if session.lives < config.starting_lives {
			session.lives += 1
			pop_score(&session.scorepop_oneup, pot_pos + Vec2{38, -24}, ScorepopType.ONEUP)
			session.scorepop_oneup.time_to_end = 4
		}

		session.state = SessionState.POST_WIN
		session.time_to_next_state = config.post_win_length
	}
}

start_food_cycle :: proc(food: ^Food, config: ^Config) {
	using food

	phase = FoodPhase.INACTIVE
	time_to_next_phase = config.food_inactive_length
	time_to_blink_toggle = 0
	is_blinking = false
	choose_next_window(food)
}

choose_next_window :: proc(food: ^Food) {
	using food 

	if active_windows_len <= 0 {
		current_window = rand.int_max(windows_len)
	} else {
		current_window = active_windows[rand.int_max(active_windows_len)]
	}
}
