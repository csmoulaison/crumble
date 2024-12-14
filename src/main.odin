package main
import "core:fmt"

// TODO
// * Implement food code logic
// * Reorganize sprite atlas and update code
// * Add alternate skins
//   * slow, fast, low grav, and final crown king
//   * 1 bit entire recolor
// * Add character icons to character specific codes -
//   AND make them work only when character selected -
//   AND make them deactivate if character changed
// * Genericize leaderboards to auto generate based on the game settings -
//   * Easiest way to build this into the current system would be making it
//     encoded in text file name

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
		else if game.session.mod_speed_state == ModSpeedState.SLOW do dt *= 0.33

		update_game(game, input, platform, dt)
		update_clock(&clock)
		platform.time_passed += dt
	}

	cleanup_platform(platform)
}
