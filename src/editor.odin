package main
import "core:mem"
import "core:strings"

ENTITY_LEN :: 4

Editor :: struct {
	data: LevelData,
	level_index: int,
	entity_types: [ENTITY_LEN]string,
	cursor_entity: int,
	cursor_position: IVec2,
	info: string,
}

init_editor :: proc(editor: ^Editor) {
	using editor

	level_index = 0
	deserialize_level(&data, 0)

	entity_types = {
		"Tile",
		"King",
		"Enemy",
		"Window",
	}
	cursor_entity = 1
	cursor_position = {320, 160}

	info = "Editor initialized"
}

update_editor :: proc(editor: ^Editor, game: ^Game, input: ^Input, fonts: ^UIFonts, sound_system: ^SoundSystem, platform: ^Platform) {
	using editor
	using editor.data

	// Check for force quit
	if input.quit.just_pressed {
		game.state = GameState.MAIN_MENU
		start_sound(sound_system, SoundType.GO_BACK)
		return
	}

	// Quicksave and quickload
	if input.editor_quicksave.just_pressed {
		ok := serialize_level(&data, level_index)
		if ok do info = "Quicksaved" 
		else do info = "Quicksave failed!"
	}
	if input.editor_quickload.just_pressed {
		ok := deserialize_level(&data, level_index)
		if ok do info = "Quickloaded" 
		else {
			info = "New level!"
			data = {}
		}
	}

	// Cycle levels
	if input.editor_incr_lvl.just_pressed {
		level_index += 1
		ok := deserialize_level(&data, level_index)
		if !ok {
			data = {}
		}
	}
	if input.editor_decr_lvl.just_pressed {
		level_index -= 1
		if level_index < 0 do level_index = 0
		deserialize_level(&data, level_index)
	}

	// Choose entity type based on input
	if input.cycle_back.just_pressed {
		cursor_entity -= 1
		if cursor_entity < 0 do cursor_entity = ENTITY_LEN - 1
	}
	if input.cycle_forward.just_pressed {
		cursor_entity += 1
		if cursor_entity > ENTITY_LEN - 1 do cursor_entity = 0
	}
	entity_type := entity_types[cursor_entity]

	// Move cursor based on input
	if input.cursor_up.just_pressed do cursor_position.y -= 16
	if input.cursor_down.just_pressed do cursor_position.y += 16
	if input.cursor_left.just_pressed do cursor_position.x -= 16
	if input.cursor_right.just_pressed do cursor_position.x += 16
	
	// Wrap cursor position
	if cursor_position.x > LOGICAL_WIDTH do cursor_position.x = cursor_position.x - LOGICAL_WIDTH
	if cursor_position.y > LOGICAL_HEIGHT do cursor_position.y = cursor_position.y - LOGICAL_HEIGHT
	if cursor_position.x < 0 do cursor_position.x = LOGICAL_WIDTH + cursor_position.x
	if cursor_position.y < 0 do cursor_position.y = LOGICAL_HEIGHT + cursor_position.y

	// Snap to grid if a tile
	if entity_type == "Tile" {
		cursor_position.x = ((cursor_position.x - 1) | 15) + 1	
		cursor_position.y = ((cursor_position.y - 1) | 15) + 1	
	}

	real_position := Vec2{f32(cursor_position.x), f32(cursor_position.y)}

	// Place tile based on input and cursor entity
	if input.place.just_pressed {
		switch entity_type {
		case "Tile":
			tile := &tiles[index_from_tile_screen_position(cursor_position)]
			if tile^ > 0 do tile^ = 0
			else do tile^ = MAX_TILE_HEALTH
		case "King":
			king_position = real_position
		case "Enemy":
			toggle_editor_entity(enemy_positions[:MAX_ENEMIES], &enemy_positions_len, real_position)
		case "Window":
			toggle_editor_entity(window_positions[:MAX_WINDOWS], &window_positions_len, real_position)
		}
	}

	// Draw
	texture_src: IRect
	origin: IVec2

	draw_editor_tilemap(&tiles, platform)
	for &window_position in window_positions[:window_positions_len] {
		draw_window(true, window_position, platform)
	}
	for &enemy_position in enemy_positions[:enemy_positions_len] {
		draw_editor_enemy(enemy_position, platform)
	}
	draw_editor_king(ivec2_from_vec2(king_position), platform)

	// Data for entity info text construction
	entity_info_text_active := true
	entity_info_name := ""
	entity_info_count := 0
	entity_info_max := 0

	// Draw cursor
	switch entity_type {
		case "Tile": 
			entity_info_text_active = false
			draw_editor_tile(cursor_position, platform)
		case "King": 
			entity_info_text_active = false
			draw_editor_king(cursor_position, platform)
		case "Enemy": 
			draw_editor_enemy(real_position, platform)
			entity_info_name = "Enemies"
			entity_info_count = enemy_positions_len
			entity_info_max = MAX_ENEMIES
		case "Window": 
			draw_window(false, real_position, platform)
			entity_info_name = "Windows"
			entity_info_count = window_positions_len
			entity_info_max = MAX_WINDOWS
	}
	
	// Draw info text
	info_line := strings.builder_make()
	strings.write_string(&info_line, "Level ")
	strings.write_int(&info_line, level_index + 1)
	strings.write_string(&info_line, " ")
	strings.write_string(&info_line, info)
	buffer_text(platform, {8, 8}, strings.to_string(info_line), fonts.white)

	// Draw entity info text
	if entity_info_text_active {
		entity_info_line := strings.builder_make()
		strings.write_string(&entity_info_line, entity_info_name)
		strings.write_string(&entity_info_line, ": ")
		strings.write_int(&entity_info_line, entity_info_count)
		strings.write_string(&entity_info_line, " of ")
		strings.write_int(&entity_info_line, entity_info_max)
		buffer_text(platform, {8, 20}, strings.to_string(entity_info_line), fonts.white)
	}
}

toggle_editor_entity :: proc(entity_positions: []Vec2, positions_len: ^int, toggle_position: Vec2) {
	for &entity_pos, i in entity_positions[:positions_len^] {
		if entity_pos == toggle_position {
			entity_positions[i] = entity_positions[positions_len^ - 1]
			positions_len^ -= 1
			return
		}
	}
	entity_positions[positions_len^] = toggle_position
	positions_len^ += 1
}

draw_editor_king :: proc(position: IVec2, platform: ^Platform) {
	buffer_sprite(
		platform, 
		IRect{{96,16},{16,21}},
		position,
		IVec2{8,21},
		false);
}

draw_editor_tilemap :: proc(tiles: ^[NUM_TILES]u8, platform: ^Platform) {
	for tile, index in tiles {
		if tile == 0 do continue

		draw_editor_tile(tile_screen_position_from_index(index), platform)
	}
}

draw_editor_enemy :: proc(enemy_position: Vec2, platform: ^Platform) {
	buffer_sprite(
		platform, 
		IRect{{192, 16}, {16, 21}},
		ivec2_from_vec2(enemy_position),
		IVec2{8,21},
		false);
}

draw_editor_tile :: proc(position: IVec2, platform: ^Platform) {
	buffer_sprite( platform, IRect{{0,0},{16,16}}, position, IVec2{8,0}, false)
}
