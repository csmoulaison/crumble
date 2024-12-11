package main
import "core:fmt"

// TODO
// Full unlock list:
// * king -> chef
//   * chef -> one_life, one_tile_health
//     * one_life -> slow, fast, low_grav
//       * slow     -> color 1 (per character)
//       * fast     -> color 2 (...)
//       * low_grav -> color 3 (...)
//     * one_tile_health -> food_hint
//       * food_hint -> builder
//         * builder -> king final

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

		dt := clock.dt
		if game.session.mod_speed_state == ModSpeedState.FAST do dt *= 1.5
		else if game.session.mod_speed_State == ModSpeedState.SLOW do dt *= 0.33

		update_game(game, input, platform, dt)
		update_clock(&clock)
		platform.time_passed += dt
	}

	cleanup_platform(platform)
}
