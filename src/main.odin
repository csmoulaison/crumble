package main
import "core:fmt"

// MAJOR cleanup required.
//     (Some might not be worth it at this stage in the project.
//     Lesson learned.)
// * Data formats for:
//   - Textures
//   - ALL config
//   - Music
//   - Input (will be porting to arcade machine soon)
// * Make state machine structure consistent
//   - What's inline with the switch? Just a function call would probably be best.
// * Any new abstraction to facillitate tandy sound port?

// To do
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
