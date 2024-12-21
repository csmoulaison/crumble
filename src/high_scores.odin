package main
import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

MAX_HIGH_SCORES :: 100
LEADERBOARD_PREFIX :: "data/"
LEADERBOARD_SUFFIX :: ".ldb"
SCORE_LETTER_COUNT :: 26

Score :: struct {
	initials: [3]rune,
	points: int,
}

LeaderboardData :: struct {
	scores: [MAX_HIGH_SCORES]Score,
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
	using game.leaderboard

	exiting: bool = false
	defer if exiting {
		serialize_leaderboard(leaderboard_fname(&game.session), &data)

		stop_music(&game.sound_system)
		game.session.king.character = Character.KING
		game.session.king.skin = Skin.DEFAULT
		game.session.mod_one_life = false
		game.session.mod_crumbled = false
		game.session.mod_random = false
		game.session.mod_speed_state = ModSpeedState.NORMAL
		game.session.food_hint_accomplished = false

		deserialize_leaderboard(leaderboard_fname(&game.session), &data)

		game.state = GameState.PRE_MAIN_MENU
		game.intro_elapsed_time = 1
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

	using game.leaderboard

	platform.logical_offset_active = false

	time_to_toggle_blink -= dt
	if time_to_toggle_blink < 0 {
		time_to_toggle_blink = config.scoreboard_editing_blink_length
		blink = !blink
	}

	// Draw mod indicators if applicable
	draw_mod_indicators(IVec2{LOGICAL_WIDTH - 33, top_margin - 16}, &session, platform)

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
	using game.leaderboard
	leaderboard_fname: string = leaderboard_fname(&game.session)
	deserialize_leaderboard(leaderboard_fname, &data)

	current_score = -1
	#reverse for score, i in data.scores[:MAX_HIGH_SCORES] {
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

	if current_score != -1 {
		current_initial = 0
	}

	serialize_leaderboard(leaderboard_fname, &data)
}

serialize_leaderboard :: proc (fname: string, data: ^LeaderboardData) -> (ok: bool) {
	bytes := mem.byte_slice(data, size_of(LeaderboardData))
    return os.write_entire_file(fname, bytes)
}

deserialize_leaderboard :: proc(fname: string, result: ^LeaderboardData) -> (ok: bool) {
    data, read_ok := os.read_entire_file(fname)
    if !read_ok {
	    cleared: LeaderboardData
	    result^ = cleared
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

// data/ + character / one_life / crumbled / random / speed_state + .score
// data/K000N.score for a regular high score
// data/C101S.score for chef with one_life and random at slow speed
leaderboard_fname :: proc(session: ^Session) -> string {
	builder := strings.builder_make()
	strings.write_string(&builder, LEADERBOARD_PREFIX)

	switch session.king.character {
	case Character.KING:
		strings.write_rune(&builder, 'K')
	case Character.CHEF:
		strings.write_rune(&builder, 'C')
	case Character.BUILDER:
		strings.write_rune(&builder, 'B')
	}

	if session.mod_one_life {
		strings.write_int(&builder, 1)
	} else {
		strings.write_int(&builder, 0)
	}

	if session.mod_crumbled {
		strings.write_int(&builder, 1)
	} else {
		strings.write_int(&builder, 0)
	}

	if session.mod_random {
		strings.write_int(&builder, 1)
	} else {
		strings.write_int(&builder, 0)
	}

	switch session.mod_speed_state {
	case ModSpeedState.NORMAL:
		strings.write_rune(&builder, 'N')
	case ModSpeedState.FAST:
		strings.write_rune(&builder, 'F')
	case ModSpeedState.SLOW:
		strings.write_rune(&builder, 'S')
	}

	strings.write_string(&builder, LEADERBOARD_SUFFIX)

	return strings.to_string(builder)
}
