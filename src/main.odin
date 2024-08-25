package main
import "core:fmt"

// ADDS
// * Music (5/7)
//   - 1: Greensleeves [X]
//   - 2: Dompe        [ ]
//   - 3: Bach         [X]
//   - 4: Speed        [X]
//   - 5: Ballarde     [ ]
//   - 6: Islands      [X]
//   - 7: Victory      [X]
// * Track prioritization last pass (food takes precedence?)
// * Any last visual telegraphs?
// * New Hannah art
// * Fucking collisions?
// * Opening screens improvement
// * Level UI improvements?

main :: proc() {
	platform: ^Platform = new(Platform)
	init_platform(platform)

	input: ^Input = new(Input)
	init_input(input)

	game: ^Game = new(Game)
	init_game(game, platform)

	clock: Clock
	init_clock(&clock)

	for !platform.ready_to_quit {
		update_platform(platform)
		update_input(input, platform)
		if input.quit.just_pressed {
			break
		}

		update_game(game, input, platform, clock.dt)
		update_clock(&clock)
		platform.time_passed += clock.dt
	}

	cleanup_platform(platform)
}
