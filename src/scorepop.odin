package main

Scorepop :: struct {
	position: IVec2,
	time_to_end: f32,
	src: IRect,
}

ScorepopType :: enum {
	LITTLE,
	BIG,
	POT,
}

update_scorepop :: proc(scorepop: ^Scorepop, dt: f32) {
	scorepop.time_to_end -= dt
}

draw_scorepop :: proc(scorepop: ^Scorepop, platform: ^Platform) {
	using scorepop
	if time_to_end > 0 {
		draw_src := src
		if int(time_to_end * 10) % 2 == 0 {
			draw_src.position.y += 8
		}

		lift :: 10
		draw_pos: IVec2 = {position.x, int(f32(position.y) + time_to_end * lift - lift)}

		buffer_sprite(platform, draw_src, draw_pos, IVec2{8,0}, false)
	}
}

pop_score :: proc(scorepop: ^Scorepop, new_position: Vec2, type: ScorepopType) {
	using scorepop

	position = ivec2_from_vec2(new_position)
	time_to_end = 1

	switch type {
	case ScorepopType.LITTLE:
		src = {{307, 16}, {5, 8}}
	case ScorepopType.BIG:
		src = {{313, 16}, {7, 8}}
	case ScorepopType.POT:
		src = {{321, 16}, {7, 8}}
	}
}
