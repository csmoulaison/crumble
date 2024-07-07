package main
import "core:strings"

@(private="file")
LINE_HEIGHT :: 16
@(private="file")
COLUMN_WIDTH :: 16
@(private="file")
LEFT_MARGIN :: 16

TowerEditor :: struct {
	data: TowerSequence,
	tower_index: int,
	level_index: int,
}

init_tower_editor :: proc(editor: ^TowerEditor) {
	using editor

	deserialize_tower_sequence(&data)
	tower_index = 0
	level_index = 0 
}

draw_tower_editor :: proc(editor: ^TowerEditor, fonts: ^UIFonts, platform: ^Platform) {
	using editor

	y := 16
	for &tower, i in data.towers {
		tower_str := strings.builder_make()
		strings.write_string(&tower_str, "Tower ")
		strings.write_int(&tower_str, i + 1)

		tower_matched := (i == tower_index)
		font := fonts.white
		if tower_matched do font = fonts.red
		buffer_text(platform, {LEFT_MARGIN, y}, strings.to_string(tower_str), font)
		y += LINE_HEIGHT

		x := LEFT_MARGIN
		for &level, j in tower.levels[:tower.len] {
			level_str := strings.builder_make()
			strings.write_int(&level_str, level + 1)

			font = fonts.white
			if j == level_index && tower_matched do font = fonts.red
			buffer_text(platform, {x, y}, strings.to_string(level_str), font)

			x += COLUMN_WIDTH
		}

		y += LINE_HEIGHT
	}
}

update_tower_editor :: proc(editor: ^TowerEditor, input: ^Input) {
	using editor

	if input.up.just_pressed {
		data.towers[tower_index].levels[level_index] += 1
	}
	if input.down.just_pressed {
		if data.towers[tower_index].levels[level_index] > 0 {
			data.towers[tower_index].levels[level_index] -= 1
		}
	}

	tower_len := data.towers[tower_index].len
	if input.left.just_pressed {
		level_index -= 1
		if level_index < 0 do level_index = tower_len - 1
	}
	if input.right.just_pressed {
		level_index += 1
		if level_index >= tower_len do level_index = 0
	}

	if input.select.just_pressed {
		tower_index += 1
		if tower_index >= TOWER_COUNT do tower_index = 0
		level_index = 0
	}

	if input.add_tower_level.just_pressed {
		if !(data.towers[tower_index].len + 1 >= MAX_TOWER_LEVELS) {
			data.towers[tower_index].len += 1
		}
	}
	if input.remove_tower_level.just_pressed {
		if !(data.towers[tower_index].len <= 0) {
			data.towers[tower_index].len -= 1
		}
	}
}
