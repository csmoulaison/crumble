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

	draw_level_indicator(IVec2{LOGICAL_WIDTH / 2 - 3, LOGICAL_HEIGHT / 2 + 60}, session, platform)

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
