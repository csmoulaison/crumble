package main
import "core:strings"

draw_level_interstitial :: proc(session: ^Session, time_to_end: f32, assets: ^Assets, platform: ^Platform, dt: f32) {
	if time_to_end < 1 {
		return
	}

	platform.logical_offset_active = true
	platform.logical_offset.x = 3
	platform.logical_offset.y = 0

	center := IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 14}
	tower_height: int = 128
	level_y_height := center.y + tower_height / 2 + 20

	// Draw level text
	level_str := strings.builder_make()
	strings.write_string(&level_str, "Level ")
	strings.write_int(&level_str, session.current_level + 1)
	buffer_text(
		platform, 
		{center.x - 31, level_y_height}, 
		strings.to_string(level_str), 
		assets.fonts.white)

	level_tower_to_draw := session.current_level

	if int((time_to_end) * 4) % 2 == 0 && time_to_end > 3 {
		level_tower_to_draw -= 1
	}

	if level_tower_to_draw < 0 {
		return
	}

	// Draw tower graphic
	buffer_sprite(
		platform,
		IRect{{736 + level_tower_to_draw * 53, 37}, {53, 128}},
		IVec2{center.x, center.y},
		IVec2{29, 64},
		false)
}

draw_pre_session_screen :: proc(session: ^Session, assets: ^Assets, platform: ^Platform, time_to_end: f32) {
	draw_str_x: int = LOGICAL_WIDTH / 2 - 12 * 8

	line_height: int = 32
	draw_str_y: int = LOGICAL_HEIGHT / 2 - int(f32(line_height) * 2.5)

	food_src_pos := IRect{{592 + 128, 0}, {16, 16}}
	food_str := strings.builder_make()
	strings.write_string(&food_str, "Eat food")
	buffer_text(platform, {draw_str_x, draw_str_y}, strings.to_string(food_str), assets.fonts.white)
	buffer_sprite(
		platform, 
		food_src_pos,
		IVec2{draw_str_x - 22, draw_str_y + 6},
		IVec2{0, 6},
		false)
	draw_str_y += line_height

	if time_to_end > 7.5 {
		return
	}

	enemy_str := strings.builder_make()
	strings.write_string(&enemy_str, "Avoid enemies")
	buffer_text(platform, {draw_str_x, draw_str_y}, strings.to_string(enemy_str), assets.fonts.white)
	buffer_sprite(
		platform, 
		assets.sequences.guard_idle.starting_frame,
		IVec2{draw_str_x - 22, draw_str_y + 6},
		IVec2{0, 11},
		false)
	draw_str_y += line_height

	if time_to_end > 6 {
		return
	}

	float_str := strings.builder_make()
	strings.write_string(&float_str, "Double jump to float")
	buffer_text(platform, {draw_str_x, draw_str_y}, strings.to_string(float_str), assets.fonts.white)
	buffer_sprite(
		platform, 
		assets.sequences.king_float.starting_frame,
		IVec2{draw_str_x - 22, draw_str_y + 6},
		IVec2{0, 9},
		false)
	draw_str_y += line_height

	if time_to_end > 4.5 {
		return
	}

	pot_src_pos := IRect{{288, 0}, {16, 16}}
	pot_str := strings.builder_make()
	strings.write_string(&pot_str, "Bounce on pot to end level")
	buffer_text(platform, {draw_str_x, draw_str_y}, strings.to_string(pot_str), assets.fonts.white)
	buffer_sprite(
		platform, 
		pot_src_pos,
		IVec2{draw_str_x - 22, draw_str_y + 6},
		IVec2{0, 8},
		false)
	draw_str_y += line_height
	
	if time_to_end > 3 {
		return
	}

	if int((time_to_end) * 4) % 2 == 0 {
		return
	}

	cont_str := strings.builder_make()
	strings.write_string(&cont_str, "Press select to continue")
	buffer_text(platform, {draw_str_x, draw_str_y}, strings.to_string(cont_str), assets.fonts.white)
}
