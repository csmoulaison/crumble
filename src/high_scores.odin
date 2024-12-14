package main
import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

MAX_HIGH_SCORES :: 100
LEADERBOARD_FNAME :: "data/leaderboard.score"
LEADERBOARD_CHEF_FNAME :: "data/leaderboard_chef.score"
LEADERBOARD_BUILDER_FNAME :: "data/leaderboard_builder.score"
SCORE_LETTER_COUNT :: 26

Score :: struct {
	initials: [3]rune,
	points: int,
}

LeaderboardData :: struct {
	scores: [MAX_HIGH_SCORES]Score,
	len: int,
}

Leaderboard :: struct {
	data: LeaderboardData,
	
	// State of editing the score
	current_score: int, // -1 if not editing any scores
	current_initial: int, // only relevant if current_score != -1
	initial_index: int, // index into array of initials
	time_to_toggle_blink: f32,
	blink: bool,
}

update_high_scores :: proc(game: ^Game, input: ^Input) {
	leaderboard := &game.leaderboard
	leaderboard_fname := LEADERBOARD_FNAME

	#partial switch game.session.king.character {
	case Character.CHEF:
		leaderboard = &game.leaderboard_chef
		leaderboard_fname = LEADERBOARD_CHEF_FNAME
	case Character.BUILDER:
		leaderboard = &game.leaderboard_builder
		leaderboard_fname = LEADERBOARD_CHEF_FNAME
	}

	using leaderboard

	exiting: bool = false
	defer if exiting {
		serialize_leaderboard(leaderboard_fname, &data)

		stop_music(&game.sound_system)
		game.session.king.character = Character.KING
		game.session.mod_one_life = false
		game.session.mod_crumbled = false
		game.session.mod_low_grav = false
		game.session.mod_speed_state = ModSpeedState.NORMAL

		game.state = GameState.PRE_MAIN_MENU
		game.intro_elapsed_time = 1
	}

	if !is_session_eligible_for_high_score(game) && (input.select.just_pressed || input.quit.just_pressed) {
		exiting = true
		return
	}

	if current_score < 0 || current_score > 9 {
		if input.select.just_pressed || input.quit.just_pressed {
			exiting = true
		}
		return
	}

	if input.up.just_pressed {
		blink = true
		time_to_toggle_blink = 0
		index := index_from_letter(data.scores[current_score].initials[current_initial]) + 1
		if index >= SCORE_LETTER_COUNT do index = 0
		data.scores[current_score].initials[current_initial] = letter_from_index(index)
	}

	if input.down.just_pressed {
		blink = true
		time_to_toggle_blink = 0
		index := index_from_letter(data.scores[current_score].initials[current_initial]) - 1
		if index < 0 do index = SCORE_LETTER_COUNT - 1
		data.scores[current_score].initials[current_initial] = letter_from_index(index)
	}

	if input.right.just_pressed || input.select.just_pressed {
		current_initial += 1
	}

	if input.left.just_pressed {
		current_initial -= 1
		if current_initial < 0 do current_initial = 0
	}

	if (input.select.just_pressed && current_initial > 2) || input.quit.just_pressed {
		exiting = true
	}
}

draw_high_scores :: proc(game: ^Game, config: ^Config, platform: ^Platform, dt: f32) {
	top_margin: int = 156
	col1_x: int = 247
	col2_x: int = 311
	col3_x: int = 374

	leaderboard := &game.leaderboard
	#partial switch game.session.king.character {
	case Character.CHEF:
		leaderboard = &game.leaderboard_chef
	case Character.BUILDER:
		leaderboard = &game.leaderboard_builder
	}

	using leaderboard

	platform.logical_offset_active = false

	time_to_toggle_blink -= dt
	if time_to_toggle_blink < 0 {
		time_to_toggle_blink = config.scoreboard_editing_blink_length
		blink = !blink
	}

	// Draw headers
	rank_text: IRect = {{245, 117}, {19, 7}}
	score_text: IRect = {{253, 110}, {24, 7}}
	name_text: IRect = {{264, 117}, {19, 7}}

	buffer_sprite(platform, rank_text, IVec2{col1_x, top_margin}, IVec2{0, 0}, false)
	buffer_sprite(platform, name_text, IVec2{col2_x, top_margin}, IVec2{0, 0}, false)
	buffer_sprite(platform, score_text, IVec2{col3_x, top_margin}, IVec2{0, 0}, false)

	// Draw score rows
	row_y: int = top_margin + 20
	place_text: IRect = {{253, 124}, {19, 7}}
	#partial switch game.session.king.character {
	case Character.CHEF:
		place_text.position.x += 19
	case Character.BUILDER:
		place_text.position.x += 38
	}

	for score, i in data.scores[:10] {
		// Draw place
		buffer_sprite(platform, place_text, IVec2{col1_x, row_y}, IVec2{0, 0}, false)

		// Draw initials
		initial_pos_x: int = col2_x + 2
		for c, j in score.initials {
			letter_index: int = index_from_letter(c)
			initial_src: IRect = {{176 + letter_index * 5, 96}, {4, 7}}

			if current_score == i && current_initial == j {
				initial_src.position.y += 7
				if blink {
					initial_src.position.x = 306
				}
			}
			
			buffer_sprite(platform, initial_src, IVec2{initial_pos_x, row_y}, IVec2{0, 0}, false)
			initial_pos_x += 5
		}

		// Draw score
		draw_score(score.points, IVec2{col3_x - 16, row_y - 2}, platform)

		// Iterate row position
		place_text.position.y += 7
		row_y += 13
	}
}

add_high_score :: proc(game: ^Game, new_score: Score) {
	leaderboard := &game.leaderboard
	leaderboard_fname: string = LEADERBOARD_FNAME
	#partial switch game.session.king.character {
	case Character.CHEF:
		leaderboard = &game.leaderboard_chef
		leaderboard_fname = LEADERBOARD_CHEF_FNAME
	case Character.BUILDER:
		leaderboard = &game.leaderboard_builder
		leaderboard_fname = LEADERBOARD_BUILDER_FNAME
	}

	using leaderboard

	if data.len > MAX_HIGH_SCORES {
		data.len = MAX_HIGH_SCORES
	}

	leaderboard.current_score = -1
	#reverse for score, i in data.scores[:data.len] {
		if score.points < new_score.points {
			if i < MAX_HIGH_SCORES - 1 {
				data.scores[i + 1] = score
			}
			data.scores[i] = new_score
			current_score = i
		} else {
			break
		}
	}

	if leaderboard.current_score != -1 {
		current_initial = 0
		if data.len < MAX_HIGH_SCORES {
			data.len += 1
		}
	}

	serialize_leaderboard(leaderboard_fname, &leaderboard.data)
}

serialize_leaderboard :: proc (fname: string, data: ^LeaderboardData) -> (ok: bool) {
	bytes := mem.byte_slice(data, size_of(LeaderboardData))
    return os.write_entire_file(fname, bytes)
}

deserialize_leaderboard :: proc(fname: string, result: ^LeaderboardData) -> (ok: bool) {
    data, read_ok := os.read_entire_file(fname)
    if !read_ok {
		result.len = 10
       return false
    }
	result^ = (^LeaderboardData)(raw_data(data))^
    return true
}

@(private="file")
index_from_letter :: proc(letter: rune) -> int {
	for c, i in get_letter_list() {
		if c == letter do return i
	}
	return 0
}

@(private="file")
letter_from_index :: proc(index: int) -> rune {
	return get_letter_list()[index]
}

@(private="file")
get_letter_list :: proc() -> [SCORE_LETTER_COUNT]rune {
	return [SCORE_LETTER_COUNT]rune {
		'A',
		'B',
		'C',
		'D',
		'E',
		'F',
		'G',
		'H',
		'I',
		'J',
		'K',
		'L',
		'M',
		'N',
		'O',
		'P',
		'Q',
		'R',
		'S',
		'T',
		'U',
		'V',
		'W',
		'X',
		'Y',
		'Z',}
}

is_session_eligible_for_high_score :: proc(game: ^Game) -> bool {
	using game.session
	return !(mod_one_life || mod_crumbled || mod_low_grav || mod_speed_state != ModSpeedState.NORMAL)
}
