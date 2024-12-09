package main

draw_level_indicator :: proc(position: IVec2, session: ^Session, platform: ^Platform) {
	max_title_width: int = 49

	level_head: IRect = {{90, 65}, {24, 8}}
	level_num_text: IRect = {{0 + session.current_level * 7, 78}, {7, 7}}
	level_title_text: IRect = {{0, 85 + session.current_level * 5}, {max_title_width, 5}}

	buffer_sprite(platform, level_head, IVec2{position.x, position.y}, IVec2{12, 0}, false)
	buffer_sprite(platform, level_num_text, IVec2{position.x, position.y + 7}, IVec2{3, 0}, false)
	buffer_sprite(platform, level_title_text, IVec2{position.x, position.y + 15}, IVec2{max_title_width / 2, 0}, false)
}
