package main
import "core:fmt"

// To do
// * Music (5/7)
//   - 1:
//   - 2:
//   - 3: Bach 1041    [X]
//   - 4: Bach 1041 2  [x]
//   - 5: Greensleeves [X]
//   - 6: Islands      [X]
//   - 7: Victory      [X]
// * Any last visual telegraphs?
// * Collisions?
//   - Yes: combine colliders while counting tiles
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
