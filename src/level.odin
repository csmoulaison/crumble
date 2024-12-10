package main
import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:math"
import "core:math/rand"

LEVEL_FNAME_PREFIX :: "levels/level"

// Initialize level data
init_level :: proc(session: ^Session, data: ^LevelData, config: ^Config) {
	using session

	time_to_next_state = config.pre_active_length
	level_points = 0

	init_tilemap(&tilemap, config, &level_data)
	init_king(&king, &level_data, config)
	init_food(&session.food, &level_data, config)
	init_enemies(&enemy_list, &level_data)

	king.foods_eaten = 0
}

// Draws the user interface for the level
draw_level :: proc(session: ^Session, king_visible: bool, assets: ^Assets, config: ^Config, platform: ^Platform, dt: f32) {
	using session

	// Draw UI
	platform.logical_offset_active = false
	
	top_margin: int = 16
	col_width: int = 64

	// Draw level indicator
	draw_level_indicator(IVec2{LOGICAL_WIDTH / 2, top_margin}, session, platform)

	// Draw score
	pos_x: int = LOGICAL_WIDTH / 2 - 72
	score_frame: IRect = {{0, 58}, {43, 20}}

	points: int = session.total_points + session.level_points
	if session.visual_points < points {
		session.visual_points_countdown -= dt
		if session.visual_points_countdown < 0 {
			session.visual_points_countdown = 0.025
			session.visual_points += 1
		}

		if (points - session.visual_points) % 4 == 0 {
			//first_num_text.position.y += 9
		}
	}

	buffer_sprite(platform, score_frame, IVec2{pos_x, top_margin}, IVec2{0, 0}, false)
	draw_score(visual_points, IVec2{pos_x - 2, top_margin + 8}, platform)

	// Draw remaining lives
	pos_x = LOGICAL_WIDTH / 2 - 122
	lives_frame: IRect = {{43, 58}, {47, 20}}
	lives_icon: IRect = {{90, 73}, {9, 9}}

	#partial switch session.king.character {
	case Character.CHEF:
		lives_icon.position.x += 9
	case Character.BUILDER:
		lives_icon.position.x += 9
	}
	
	buffer_sprite(platform, lives_frame, IVec2{pos_x, top_margin}, IVec2{0, 0}, false)
	for i in 0..<lives {
		buffer_sprite(platform, lives_icon, IVec2{pos_x + 4 + i * 10, top_margin + 8}, IVec2{0, 0}, false)
	}

	// Draw foods
	pos_x = LOGICAL_WIDTH / 2 + 30
	food_text: IRect = {{90, 58}, {19, 7}}

	buffer_sprite(platform, food_text, IVec2{pos_x, top_margin}, IVec2{0, 0}, false)
	for i: int = 0; i < int(session.king.foods_eaten); i += 1 {
		buffer_sprite(platform, IRect{{592 + session.food.eaten_food_offsets[i], 0},{16,16}}, IVec2{pos_x - 4 + i * 11, top_margin + 12}, IVec2{0,8}, false)
	}

	// Draw non-UI level
	platform.logical_offset_active = true
	// Stop making fun of me
	platform.logical_offset.x = 64
	platform.logical_offset.y = 32
	if session.current_level == 1 || session.current_level == 5 {
		platform.logical_offset.x = 80
	}

	draw_food(&food, platform)
	draw_tilemap(&tilemap, &assets.sequences, session.current_level, platform)
	if(king_visible) {
		draw_king(&king, 0, &assets.sequences, platform, dt)
	}
	draw_enemies(&enemy_list, &assets.sequences, platform, dt)

	draw_scorepop(&scorepop, platform)
	draw_scorepop(&scorepop_oneup, platform)
}

serialize_level :: proc(data: ^LevelData, index: int) -> (ok: bool) {
	bytes := mem.byte_slice(data, size_of(LevelData))
    return os.write_entire_file(get_level_fname(index), bytes)
}

deserialize_level :: proc(result: ^LevelData, index: int) -> (ok: bool) {
    data, read_ok := os.read_entire_file(get_level_fname(index))
    if !read_ok {
       return false
    }
	result^ = (^LevelData)(raw_data(data))^
    return true
}

@(private="file")
get_level_fname :: proc(index: int) -> string {
	fname := strings.builder_make()
	strings.write_string(&fname, LEVEL_FNAME_PREFIX)
	strings.write_int(&fname, index)
	strings.write_string(&fname, ".lvl")
	return strings.to_string(fname)
}
