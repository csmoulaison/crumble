package main
import "core:fmt"

// TODO
// * Indicators of game mode for high score/pre menu screen (+interstitials?)
// * Co-op multiplayer

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
		platform.clock += dt
	}

	cleanup_platform(platform)
}
