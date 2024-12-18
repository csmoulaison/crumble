package main
import "core:strings"

draw_level_interstitial :: proc(session: ^Session, time_to_end: f32, assets: ^Assets, platform: ^Platform, dt: f32) {
	if time_to_end < 1 {
		return
	}

	platform.logical_offset_active = false

	draw_level_indicator(IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 + 60}, session, platform)
	level_tower_to_draw := session.current_level

	if int((time_to_end) * 4) % 2 == 0 && time_to_end > 3 {
		level_tower_to_draw -= 1
		if level_tower_to_draw < 0 {
			return
		}
	}

	tower_src: IRect = {{310, 252}, {53, 0}}
	x_off: int = 0
	y_size: int = 0
	switch level_tower_to_draw {
	case 0:
		y_size = 23
	case 1:
		y_size = 47
	case 2:
		y_size = 71
	case 3:
		x_off = 53
		y_size = 92
	case 4:
		x_off = 53
		y_size = 114
	case 5:
		x_off = 53
		y_size = 123
	}
	tower_src.position.x += x_off
	tower_src.position.y -= y_size
	tower_src.size.y += y_size

	// Draw tower graphic
	buffer_sprite(
		platform,
		tower_src,
		IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 + 32 - y_size},
		IVec2{27, 0},
		false)

	platform.logical_offset_active = true
}
