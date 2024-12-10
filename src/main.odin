package main
import "core:fmt"

// TODO
// * Chef leads to ...
//   * Sudden death leads to (direct unlock) ...
//     * Mathilda character leads to ...
//       * Fun cheats (slow, fast, etc.)
//   * Single health tiles leads to ...
//     * Food hint (certain food order on first level)
//       Calibrate number of foods to achieve the right chaos
//       Leads to ...
//       * Builder character

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
