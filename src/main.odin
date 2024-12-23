package main
import "core:fmt"

// TODO
// * Co-op multiplayer
// * ^ Controller selection
//   * Array of Input, bound to buttons
//   * One Input for P1 variants, one for P2, with more for external controllers
//   * In singeplayer, all inputs aggregated before being sent to king control
//   * In multiplayer, input is selected before play, and sent per selection
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
		//if input.quit.just_pressed {
			//break
		//}

		dt := clock.dt
		if game.session.mod_speed_state == ModSpeedState.FAST do dt *= 1.5
		else if game.session.mod_speed_state == ModSpeedState.SLOW do dt *= 0.33

		update_game(game, input, platform, dt)
		update_clock(&clock)
		platform.clock += dt
	}

	cleanup_platform(platform)
}
