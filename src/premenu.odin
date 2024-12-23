package main
import "core:fmt"

START_GLITCH :: 500

// Character codes
code_chef:     [secret_code_len]int: { 0, 0, 1, 1, 0, 1, 0, 1, }
code_builder:  [secret_code_len]int: { 1, 0, 0, 1, 0, 0, 1, 1, }
// Modifier codes
code_one_life: [secret_code_len]int: { 0, 1, 0, 0, 1, 0, 1, 1, }
code_crumbled: [secret_code_len]int: { 1, 0, 1, 1, 0, 1, 0, 0, }
code_random:   [secret_code_len]int: { 1, 1, 1, 0, 1, 1, 0, 0, }
code_slow:     [secret_code_len]int: { 0, 0, 1, 0, 1, 0, 0, 1, }
code_fast:     [secret_code_len]int: { 1, 0, 0, 1, 0, 1, 1, 0, }
// Alternate skin codes
code_king1:    [secret_code_len]int: { 1, 1, 0, 0, 1, 1, 0, 1, }
code_king2:    [secret_code_len]int: { 0, 1, 1, 0, 0, 0, 0, 1, }
code_king_fin: [secret_code_len]int: { 1, 1, 1, 0, 1, 1, 0, 1, }
code_king_sha: [secret_code_len]int: { 0, 1, 1, 0, 0, 1, 0, 1, }
code_chef1:    [secret_code_len]int: { 1, 0, 0, 1, 1, 1, 1, 0, }
code_chef2:    [secret_code_len]int: { 1, 1, 1, 0, 0, 0, 1, 1, }
code_builder1: [secret_code_len]int: { 0, 1, 0, 1, 0, 1, 1, 1, }
code_builder2: [secret_code_len]int: { 1, 1, 1, 0, 1, 0, 1, 0, }
// Food code sequence. Only the first 4 are real
code_food:     [secret_code_len]int: { 1, 3, 0, 2, 0, 0, 0, 0, }

update_pre_menu :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

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
		draw_high_scores(game, &config, platform, dt)
	}

	if title {
		pos_x: int = LOGICAL_WIDTH / 2 - 7 * 6
		pos_y: int = LOGICAL_HEIGHT - 64
		token_text: IRect = {{239, 194}, {56, 7}}
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

	if platform.mod_glitchy {
		epilepsy_warning: IRect = {{310, 128}, {39, 16}}
		if int(intro_elapsed_time * 8) % 2 == 0 {
			epilepsy_warning.position.y += 16
		}
		buffer_sprite(platform, epilepsy_warning, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 112}, IVec2{19, 8}, false)
	}

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

	if !input.jump.just_pressed {
		return
	}

	code_success: bool = false
	// Characters
	if secret_code_inputs == code_chef {
		session.king.character = Character.CHEF
		session.king.skin = Skin.DEFAULT
		start_sound(&sound_system, SoundType.FOOD_EAT)
		code_success = true
	} else if secret_code_inputs == code_builder {
		session.king.character = Character.BUILDER
		session.king.skin = Skin.DEFAULT
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	// Big mods
	} else if secret_code_inputs == code_one_life {
		session.mod_one_life = true
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_crumbled {
		session.mod_crumbled = true
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	// Little mods
	} else if secret_code_inputs == code_slow {
		session.mod_speed_state = ModSpeedState.SLOW
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_fast {
		session.mod_speed_state = ModSpeedState.FAST
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_random {
		session.mod_random = true
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	// Skins
	// King
	} else if secret_code_inputs == code_king1 && session.king.character == Character.KING {
		session.king.skin = Skin.ALT_ONE
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_king2 && session.king.character == Character.KING {
		session.king.skin = Skin.ALT_TWO
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_king_fin && session.king.character == Character.KING {
		session.king.skin = Skin.CROWN_KING
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_king_sha && session.king.character == Character.KING {
		platform.mod_glitchy = true
		platform.glitch_chance = START_GLITCH
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	// Chef
	} else if secret_code_inputs == code_chef1 && session.king.character == Character.CHEF {
		session.king.skin = Skin.ALT_ONE
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_chef2 && session.king.character == Character.CHEF {
		session.king.skin = Skin.ALT_TWO
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	// Builder
	} else if secret_code_inputs == code_builder1 && session.king.character == Character.BUILDER {
		session.king.skin = Skin.ALT_ONE
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	} else if secret_code_inputs == code_builder2 && session.king.character == Character.BUILDER {
		session.king.skin = Skin.ALT_TWO
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		code_success = true
	}

	if code_success {
		deserialize_leaderboard(leaderboard_fname(&game.session), &game.leaderboard.data)
		for i in 0..<secret_code_len {
			secret_code_inputs[i] = -1
		}
		return
	}

	if input.jump.just_pressed {
		init_session(game, &game.config)
		state = GameState.SESSION
		return
	}
}

draw_pre_credits :: proc(title: bool, game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	platform.logical_offset_active = false

	total_time: f32 = 15

	main_title: IRect = {{176, 156}, {63, 34}}
	conner_credit: IRect = {{176, 128}, {77, 14}}
	hannah_credit: IRect = {{176, 142}, {77, 14}}

	if title {
		buffer_sprite(platform, main_title, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 64}, IVec2{31, 17}, false)
	}
	buffer_sprite(platform, conner_credit, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 24}, IVec2{39, 7}, false)
	buffer_sprite(platform, hannah_credit, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2}, IVec2{39, 7}, false)

	draw_mod_indicators(IVec2{LOGICAL_WIDTH / 2 - 33, LOGICAL_HEIGHT / 2 - 98}, &session, platform)
}
