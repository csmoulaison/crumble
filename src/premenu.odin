package main

update_pre_menu :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	if input.jump.just_pressed {
		init_session(&game.session, &game.config)
		state = GameState.SESSION
		return
	}

	intro_elapsed_time += dt
	switch int(intro_elapsed_time / 4) % 3 {
	case 0:
		draw_pre_credits(game, input, platform, dt)
	case 1:
		draw_pre_rules(game, input, platform, dt)
	case 2:
		game.leaderboard.current_score = -1
		draw_high_scores(&leaderboard, &config, &assets.fonts, platform, dt)
	}

	pos_x: int = LOGICAL_WIDTH / 2 - 7 * 6
	pos_y: int = LOGICAL_HEIGHT - 16
	font := assets.fonts.red
	if int(intro_elapsed_time) % 2 != 0 {
		font = assets.fonts.white
	}
	if int(intro_elapsed_time * 2) % 2 != 0 {
		buffer_text(platform, IVec2{pos_x, pos_y}, "Insert Token", font)
	}
}

draw_pre_credits :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	total_time: f32 = 15

	row_height: int = 26
	pos_y: int = 8
	pos_x: int = 8

	buffer_text(platform, IVec2{pos_x, pos_y}, "Programmer", assets.fonts.red)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Conner Moulaison", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Artists", assets.fonts.red)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Hannah Rants", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Conner Moulaison", assets.fonts.white)

	pos_y = 8
	pos_x = 196

	buffer_text(platform, IVec2{pos_x, pos_y}, "Technologies", assets.fonts.red)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Odin Language", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "SDL 2", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Miniaudio", assets.fonts.white)

	pos_y = 8
	pos_x = 350

	buffer_text(platform, IVec2{pos_x, pos_y}, "Music", assets.fonts.red)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Greensleeves", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "BWV 1041", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "What if I", assets.fonts.white)
	pos_y += row_height
	buffer_text(platform, IVec2{pos_x, pos_y}, "Never Speed?", assets.fonts.white)
	pos_y += row_height

	pos_x = LOGICAL_WIDTH / 2 - 7 * 8
	pos_y = LOGICAL_HEIGHT / 3 * 2
	
}

draw_pre_rules :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

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
