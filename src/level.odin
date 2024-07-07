package main
import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:math"
import "core:math/rand"

// Initialize level data
init_level :: proc(session: ^Session, data: ^LevelData, config: ^Config) {
	using session

	time_to_next_state = config.level.pre_active_length
	level_points = 0

	init_tilemap(&tilemap, &level_data)
	init_king(&king, &level_data, &config.king)
	init_food(&food, &level_data, &config.food)
	init_enemies(&enemy_list, &level_data, &config.enemy)

	king.foods_eaten = 0
}

// Draws the user interface for the level
draw_level :: proc(session: ^Session, king_visible: bool, assets: ^Assets, config: ^Config, platform: ^Platform, dt: f32) {
	using session

	// Draw level
	draw_food(&food, platform)
	draw_tilemap(&tilemap, &assets.sequences, session.current_level, platform)
	if(king_visible) {
		draw_king(&king, 0, &assets.sequences, platform, dt)
	}
	draw_enemies(&enemy_list, &assets.sequences, platform, dt)
	draw_scorepop(&scorepop, platform)
	
	pos_y: int = 0

	col_width: int = LOGICAL_WIDTH / 4
	pos_x: int = LOGICAL_WIDTH - (col_width / 2) * 7 - 7 * 4

	buffer_text(platform, {pos_x, pos_y}, "Level", assets.fonts.red)
	level_str := strings.builder_make()
	strings.write_int(&level_str, session.current_level + 1)
	buffer_text(platform, {pos_x, pos_y + 20}, strings.to_string(level_str), assets.fonts.white)

	pos_x += col_width

	buffer_text(platform, {pos_x, pos_y}, "Lives", assets.fonts.red)
	for i: int = 0; i < session.lives; i += 1 {
		buffer_sprite(platform, assets.sequences.king_float.starting_frame, IVec2{pos_x + i * 18, pos_y + 18}, IVec2{0,0}, false)
	}

	pos_x += col_width

	buffer_text(platform, {pos_x, pos_y}, "Foods", assets.fonts.red)

	rng: rand.Rand
	rand.init(&rng, u64(session.current_level))
	for i: int = 0; i < int(session.king.foods_eaten); i += 1 {
		food_off_x: int = rand.int_max(4, &rng) * 128

		y_off: = int(i / 8) * 20
		x_off: = -int(i / 8) * 8 * 14

		buffer_sprite(platform, IRect{{592 + food_off_x, 0},{16,16}}, IVec2{pos_x - 4 + i * 14 + x_off, pos_y + 20 + y_off}, IVec2{0,0}, false)
	}

	pos_x += col_width

	buffer_text(platform, {pos_x, pos_y}, "Score", assets.fonts.red)
	score_str := strings.builder_make()
	strings.write_int(&score_str, session.level_points + session.total_points)
	buffer_text(platform, {pos_x, pos_y + 20}, strings.to_string(score_str), assets.fonts.white)
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
