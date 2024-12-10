package main
import "core:fmt"

update_pre_menu :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	platform.logical_offset_active = false

	secret_code: [secret_code_len]^Button = {
		&input.left,
		&input.left,
		&input.right,
		&input.left,
		&input.left,
		&input.right,
		&input.right,
	};

	secret_code_builder: [secret_code_len]^Button = {
		&input.left,
		&input.left,
		&input.right,
		&input.right,
		&input.right,
		&input.left,
		&input.right,
	};

	if input.left.just_pressed || input.right.just_pressed {
		for i in 0..<secret_code_len - 1 {
			secret_code_inputs[i] = secret_code_inputs[i + 1]
		}
		if input.left.just_pressed {
			secret_code_inputs[secret_code_len - 1] = &input.left
		} else {
			secret_code_inputs[secret_code_len - 1] = &input.right
		}
	}

	if secret_code_inputs == secret_code {
		session.king.character = Character.CHEF
		start_sound(&sound_system, SoundType.FOOD_EAT)
		stop_music(&sound_system)

		for i in 0..<secret_code_len {
			secret_code_inputs[i] = nil
		}
	}

	if secret_code_inputs == secret_code_builder {
		session.king.character = Character.BUILDER
		start_sound(&sound_system, SoundType.FOOD_APPEAR)
		stop_music(&sound_system)

		for i in 0..<secret_code_len {
			secret_code_inputs[i] = nil
		}
	}

	if input.jump.just_pressed {
		init_session(&game.session, &game.config)
		state = GameState.SESSION
		return
	}

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
		secret_leaderboard.current_score = -1
		draw_high_scores(game, &config, platform, dt)
	}

	if title {
		pos_x: int = LOGICAL_WIDTH / 2 - 7 * 6
		pos_y: int = LOGICAL_HEIGHT - 64
		token_text: IRect = {{114, 58}, {56, 7}}
		if int(intro_elapsed_time) % 2 != 0 {
			token_text.position.y += 7

			#partial switch session.king.character {
			case Character.CHEF:
				token_text.position.y += 7
			case Character.BUILDER:
				token_text.position.y += 7
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

draw_pre_rules :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	if premenu_cycle_bang {
		premenu_cycle_index += 1
		premenu_cycle_bang = false
	}

	total_time: f32 = 15

	header_height: int = 26
	row_height: int = 32
	pos_y: int = 8
	pos_x: int = 8

	buffer_text(platform, IVec2{pos_x, pos_y}, "Rules", assets.fonts.red)
	pos_y += header_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Eat food", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Avoid enemies", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Double jump to float", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Bounce on pot to end level", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Beware of crumbling floor", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Eating makes you heavier", assets.fonts.white)

	pos_y = 8
	pos_x = 256

	buffer_text(platform, IVec2{pos_x, pos_y}, "Tips", assets.fonts.red)
	pos_y += header_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Float in opposite", assets.fonts.white)
	pos_y += header_height - 2
	buffer_text(platform, IVec2{pos_x, pos_y}, "direction for a boost", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Stay in the air", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Enemies are stunned by", assets.fonts.white)
	pos_y += header_height - 2
	buffer_text(platform, IVec2{pos_x, pos_y}, "losing sight of you", assets.fonts.white)
}
