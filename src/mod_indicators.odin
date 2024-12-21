package main

draw_mod_indicators :: proc(position: IVec2, session: ^Session, platform: ^Platform) {
	slot_width: int = 11

	chef: IRect = {{271, 238}, {9, 9}}
	builder: IRect = {{280, 238}, {9, 9}}
	character_pos: IVec2 = {position.x, position.y}

	one_life: IRect = {{262, 229}, {7, 9}}
	one_life_pos: IVec2 = {position.x + slot_width, position.y}

	crumbled: IRect = {{286, 229}, {7, 9}}
	crumbled_pos: IVec2 = {position.x + slot_width * 2, position.y}

	fast: IRect = {{270, 229}, {7, 9}}
	slow: IRect = {{278, 229}, {7, 9}}
	speed_pos: IVec2 = {position.x + slot_width * 3, position.y}

	random: IRect = {{294, 229}, {7, 9}}
	random_pos: IVec2 = {position.x + slot_width * 4, position.y}

	if session.king.character == Character.CHEF {
		buffer_sprite(platform, chef, character_pos, IVec2{0,0}, false)
	} else if session.king.character == Character.BUILDER {
		buffer_sprite(platform, builder, character_pos, IVec2{0,0}, false)
	}

	if session.mod_one_life {
		buffer_sprite(platform, one_life, one_life_pos, IVec2{0, 0}, false)
	}

	if session.mod_crumbled {
		buffer_sprite(platform, crumbled, crumbled_pos, IVec2{0, 0}, false)
	}

	if session.mod_speed_state == ModSpeedState.FAST {
		buffer_sprite(platform, fast, speed_pos, IVec2{0, 0}, false)
	} else if session.mod_speed_state == ModSpeedState.SLOW {
		buffer_sprite(platform, slow, speed_pos, IVec2{0, 0}, false)
	}

	if session.mod_random {
		buffer_sprite(platform, random, random_pos, IVec2{0, 0}, false)
	}
}
