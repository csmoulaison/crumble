package main
import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

MAX_HIGH_SCORES :: 100
LEADERBOARD_FNAME :: "data/leaderboard.score"
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

update_high_scores :: proc(leaderboard: ^Leaderboard, input: ^Input) {
	using leaderboard

	if current_score < 0 || current_score > 9 {
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
}

draw_high_scores :: proc(leaderboard: ^Leaderboard, config: ^Config, fonts: ^UIFonts, platform: ^Platform, dt: f32) {
	using leaderboard

	time_to_toggle_blink -= dt
	if time_to_toggle_blink < 0 {
		time_to_toggle_blink = config.scoreboard_editing_blink_length
		blink = !blink
	}

	suffixes: [10]string = { "st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", };

	col_width: int = LOGICAL_WIDTH / 4
	pos_x_1: int = LOGICAL_WIDTH / 2 - col_width
	pos_x_2: int = pos_x_1 + col_width - 7 * 2
	pos_x_3: int = pos_x_2 + col_width - 5 * 2

	row_height: int = 26
	pos_y: int = LOGICAL_HEIGHT / 2 - 6 * row_height + row_height / 2

	buffer_text(platform, {pos_x_1 - 3, pos_y}, "RANK", fonts.white)
	buffer_text(platform, {pos_x_2 - 3, pos_y}, "SCORE", fonts.white)
	buffer_text(platform, {pos_x_3 - 3, pos_y}, "NAME", fonts.white)
	pos_y += row_height

	for score, i in data.scores[:10] {
		font := fonts.white
		if current_score == i {
			font = fonts.red
		}

		place_str := strings.builder_make()
		strings.write_int(&place_str, i + 1)
		strings.write_string(&place_str, suffixes[i])
		buffer_text(platform, {pos_x_1, pos_y}, strings.to_string(place_str), font)

		score_str := strings.builder_make()
		strings.write_int(&score_str, score.points)
		buffer_text(platform, {pos_x_2, pos_y}, strings.to_string(score_str), fonts.red)

		for c, j in score.initials {
			initial_str := strings.builder_make()
			initial_off_x := 0

			if current_score == i {
				font = fonts.white
				if current_initial == j {
					font = fonts.red
					if blink {
						strings.write_rune(&initial_str, '.')
						initial_off_x += 1
					} else {
						strings.write_rune(&initial_str, c)
					}
				} else {
					strings.write_rune(&initial_str, c)
				}
			} else {
				strings.write_rune(&initial_str, c)
			}
			buffer_text(platform, {pos_x_3 + 8 * j + initial_off_x, pos_y}, strings.to_string(initial_str), font)
		}
		pos_y += row_height
	}
}

add_high_score :: proc(leaderboard: ^Leaderboard, new_score: Score) {
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

	serialize_leaderboard(&leaderboard.data)
}

serialize_leaderboard :: proc (data: ^LeaderboardData) -> (ok: bool) {
	bytes := mem.byte_slice(data, size_of(LeaderboardData))
    return os.write_entire_file(LEADERBOARD_FNAME, bytes)
}

deserialize_leaderboard :: proc(result: ^LeaderboardData) -> (ok: bool) {
    data, read_ok := os.read_entire_file(LEADERBOARD_FNAME)
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
