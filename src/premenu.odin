package main
import "core:fmt"

// Character codes
code_chef:     [secret_code_len]int: { 0, 0, 1, 1, 0, 1, 0, 1, }
code_builder:  [secret_code_len]int: { 1, 0, 0, 1, 0, 0, 1, 1, }
// Modifier codes
code_one_life: [secret_code_len]int: { 0, 0, 1, 0, 1, 1, 0, 1, }
code_crumbled: [secret_code_len]int: { 1, 1, 0, 1, 0, 0, 1, 0, }
code_low_grav: [secret_code_len]int: { 1, 1, 1, 0, 1, 1, 0, 0, }
code_slow:     [secret_code_len]int: { 0, 0, 1, 0, 1, 0, 0, 1, }
code_fast:     [secret_code_len]int: { 1, 0, 0, 1, 0, 1, 1, 0, }
// Alternate skin codes
code_king1:    [secret_code_len]int: { 1, 1, 0, 0, 1, 1, 0, 1, }
code_king2:    [secret_code_len]int: { 0, 1, 1, 0, 0, 0, 0, 1, }
code_king3:    [secret_code_len]int: { 0, 0, 0, 1, 1, 1, 0, 0, }
code_king_fin: [secret_code_len]int: { 1, 1, 1, 0, 1, 1, 0, 1, }
code_chef1:    [secret_code_len]int: { 1, 0, 0, 1, 1, 1, 1, 0, }
code_chef2:    [secret_code_len]int: { 1, 1, 1, 0, 0, 0, 1, 1, }
code_chef3:    [secret_code_len]int: { 0, 0, 1, 1, 0, 0, 1, 0, }
code_builder1: [secret_code_len]int: { 0, 1, 0, 1, 0, 1, 1, 1, }
code_builder2: [secret_code_len]int: { 1, 1, 1, 0, 1, 0, 1, 0, }
code_builder3: [secret_code_len]int: { 0, 0, 1, 1, 0, 1, 1, 0, }
// Food code sequence. Only the first 4 are real
code_food:     [secret_code_len]int: { 2, 4, 1, 3, 0, 0, 0, 0, }
// Final bonus
code_1bit:     [secret_code_len]int: { 1, 1, 1, 0, 1, 1, 0, 1, }

update_pre_menu :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	if input.left.just_pressed || input.right.just_pressed {
		for i in 0..<secret_code_len - 1 {
			secret_code_inputs[i] = secret_code_inputs[i + 1]
		}
		if input.left.just_pressed {
			secret_code_inputs[secret_code_len - 1] = 0
		} else {
			secret_code_inputs[secret_code_len - 1] = 1
		}
	}

	code_success: bool = false
	if secret_code_inputs == code_chef {
		session.king.character = Character.CHEF
		start_sound(&sound_system, SoundType.FOOD_EAT)
		code_success = true
	} else if secret_code_inputs == code_builder {
		session.king.character = Character.BUILDER
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_one_life {
		session.mod_one_life = true
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_crumbled {
		session.mod_crumbled = true
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_slow {
		session.mod_speed_state = ModSpeedState.SLOW
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_fast {
		session.mod_speed_state = ModSpeedState.FAST
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_low_grav {
		session.mod_low_grav = true
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	}

	if code_success {
		for i in 0..<secret_code_len {
			secret_code_inputs[i] = -1
		}
	}

	if input.jump.just_pressed {
		init_session(&game.session, &game.config)
		state = GameState.SESSION
		return
	}

	platform.logical_offset_active = false

	title: bool = false
	if intro_elapsed_time > 1 {
		title = true
	}

	intro_elapsed_time += dt
	switch int(intro_elapsed_time / 6) % 2 {
	case 0:
		draw_pre_credits(title, game, input, platform, dt)
	case 1:
		leaderboard.current_score = -1
		leaderboard_chef.current_score = -1
		leaderboard_builder.current_score = -1
		draw_high_scores(game, &config, platform, dt)
	}

	if title {
		pos_x: int = LOGICAL_WIDTH / 2 - 7 * 6
		pos_y: int = LOGICAL_HEIGHT - 64
		token_text: IRect = {{229, 37}, {56, 7}}
		if int(intro_elapsed_time) % 2 != 0 {
			token_text.position.y += 7

			#partial switch session.king.character {
			case Character.CHEF:
				token_text.position.y += 7
			case Character.BUILDER:
				token_text.position.y += 14
			}
		}
		if int(intro_elapsed_time * 2) % 2 == 0 {
			buffer_sprite(platform, token_text, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 + 80}, IVec2{28, 3}, false)
		}
	}
}

draw_pre_credits :: proc(title: bool, game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	platform.logical_offset_active = false

	total_time: f32 = 15

	main_title: IRect = {{77, 100}, {63, 34}}
	conner_credit: IRect = {{0, 115}, {77, 14}}
	hannah_credit: IRect = {{0, 129}, {77, 14}}

	if title {
		buffer_sprite(platform, main_title, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 64}, IVec2{31, 17}, false)
	}
	buffer_sprite(platform, conner_credit, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 24}, IVec2{39, 7}, false)
	buffer_sprite(platform, hannah_credit, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2}, IVec2{39, 7}, false)
}
