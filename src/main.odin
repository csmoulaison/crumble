package main
import "core:fmt"

// ADDS
// * Fireworks ending
// * Music (6 + 1)

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