package main
import "core:math"
import "core:fmt"

Session :: struct {
	state: SessionState,
	time_to_next_state: f32,

	// Sequence data
	tower_sequence: TowerSequence,
	current_tower: int,
	current_level: int,
	level_data: LevelData,

	// Overall session state
	total_points: int,
	lives: int,

	// Level state
	level_points: int,
	king: King,
	food: Food,
	enemy_list: EnemyList,
	tilemap: Tilemap,
	surface_map: SurfaceMap,
	scorepop: Scorepop,
	scorepop_oneup: Scorepop,
	particle_system: ParticleSystem,

	// UI state
	visual_points: int,
	visual_points_countdown: f32,

	// Modifier state
	mod_one_life: bool,
	mod_crumbled: bool,
	mod_low_grav: bool,
	mod_speed_state: ModSpeedState,
	mod_config: Config,
	food_hint_accomplished: bool,
}

SessionState :: enum {
	WAITING_TO_START,
	LEVEL_ACTIVE,
	FOOD_RESET,
	HITCH,
	POST_WIN,
	POST_LOSS,
	PRE_LEVEL_SCREEN,
	PRE_SESSION_SCREEN,
	END,
	FINAL_SCREEN,
}

init_session :: proc(session: ^Session, config: ^Config) {
	using session

	mod_config = config^
	if mod_low_grav {
		mod_config.king_max_speed *= rand_mod()
		mod_config.king_base_acceleration *= rand_mod()
		mod_config.enemy_patrol_speed *= rand_mod()
		mod_config.enemy_chase_speed *= rand_mod()
	}

	deserialize_tower_sequence(&tower_sequence)

	current_tower = 0
	current_level = 0
	total_points = 0
	visual_points = 0

	lives = config.starting_lives

	deserialize_level(&level_data, tower_sequence.towers[current_tower].levels[current_level])
	init_level(session, &level_data, config)
	init_fireworks(&particle_system)

	//state = SessionState.FINAL_SCREEN
	//king.character = Character.CHEF
	state = SessionState.PRE_LEVEL_SCREEN
	time_to_next_state = config.level_interstitial_length
}

handle_session :: proc(session: ^Session, input: ^Input, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> (ready_to_close: bool) {
	using session

	// DEBUG level advancer
	if input.editor_incr_lvl.just_pressed {
		try_advance_level(session, config)
		return false
	}

	if mod_one_life && lives > 0 {
		lives = 0
	}

	#partial switch state {
	case SessionState.LEVEL_ACTIVE:
		state = handle_level_active(session, input, &level_data, &mod_config, sound_system, dt)
	case SessionState.WAITING_TO_START:
		handle_waiting_to_start(session, input, sound_system, dt)
	case SessionState.HITCH:
		time_to_next_state -= dt
		if time_to_next_state < 0 do state = SessionState.LEVEL_ACTIVE
	case SessionState.FOOD_RESET:
		state = handle_food_reset(session, config, sound_system, dt)
	case SessionState.POST_WIN:
		state = handle_post_win(session, config, dt)
	case SessionState.POST_LOSS:
		state = handle_post_loss(session, config, dt)
	case SessionState.PRE_LEVEL_SCREEN:
		time_to_next_state -= dt
		if time_to_next_state < 0 || input.jump.just_pressed {
			time_to_next_state = config.pre_active_length
			state = SessionState.WAITING_TO_START
		}
	case SessionState.PRE_SESSION_SCREEN:
		time_to_next_state -= dt
		if input.jump.just_pressed {
			time_to_next_state = config.level_interstitial_length
			state = SessionState.PRE_LEVEL_SCREEN
			start_sound(sound_system, SoundType.ENEMY_ALARMED)
		}
	case SessionState.FINAL_SCREEN:
		handle_final_screen(session, input, dt)
	}

	update_scorepop(&scorepop, dt)
	update_scorepop(&scorepop_oneup, dt * 2)

	// Check for force exit
	if input.quit.just_pressed {
		state = SessionState.END
	}

	if state == SessionState.END {
		return true
	}
	return false
}

draw_session :: proc(session: ^Session, assets: ^Assets, config: ^Config, sound_system: ^SoundSystem, platform: ^Platform, dt: f32) {
	using session

	if state == SessionState.HITCH ||
	state == SessionState.LEVEL_ACTIVE ||
	state == SessionState.FOOD_RESET ||
	state == SessionState.POST_WIN ||
	state == SessionState.POST_LOSS {
		draw_level(session, true, assets, config, platform, dt)
   	}

	#partial switch(state) {
	case SessionState.FINAL_SCREEN:
	   	draw_final_screen(session, assets, config, sound_system, platform, dt)
	case SessionState.WAITING_TO_START:
        king_y_offset: f32 = 0
        move_king_float_start(time_to_next_state, &king, &king_y_offset, config)
        draw_level(session, false, assets, config, platform, dt)
		draw_king(&king, int(king_y_offset), &assets.sequences, platform, dt)
	case SessionState.PRE_LEVEL_SCREEN:
		draw_level_interstitial(session, time_to_next_state, assets, platform, dt)
	}
}

/* Tries to advance and initialize level, returning false if associated file
isn't found or if sequence is over. Also adds level points to total points.*/
try_advance_level :: proc(session: ^Session, config: ^Config) -> (next_level_exists: bool, tower_end: bool) {
	using session

	total_points += level_points

	current_level += 1
	if current_level >= tower_sequence.towers[current_tower].len {
		//current_level = 0
		//current_tower += 1
		//tower_end = true
		//if current_tower >= TOWER_COUNT {
			return false, false
		//}
	}

	ok := deserialize_level(&level_data, tower_sequence.towers[current_tower].levels[current_level])
	if !ok {
		current_tower -= 1
		return false, false
	}

	init_level(session, &level_data, config)
	return true, tower_end
}
