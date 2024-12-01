package main
import "core:fmt"

GameState :: enum {
	MAIN_MENU,
	SESSION,
	HIGH_SCORES,
	PRE_MAIN_MENU,
	QUIT,
}

Game :: struct {
	state: GameState,
	assets: Assets,
	config: Config,

	// State specific data
	main_menu: MainMenu,
	session: Session,
	leaderboard: Leaderboard,
	sound_system: SoundSystem,
	intro_elapsed_time: f32,
}

init_game :: proc(game: ^Game, platform: ^Platform) {
	using game

	load_assets(&assets, platform)
	deserialize_leaderboard(&leaderboard.data)
	init_main_menu(&main_menu)
	init_config(&game.config)
	init_sound_system(&game.sound_system)

	state = GameState.PRE_MAIN_MENU
}

update_game :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	switch state {
	case GameState.MAIN_MENU:
		handle_main_menu(game, &main_menu, input, &sound_system)
		draw_main_menu(&main_menu, &assets, platform, dt)
	case GameState.SESSION:
		handle_session(&session, input, &config, &sound_system, dt)
		draw_session(&session, &assets, &config, &sound_system, platform, dt)

		if session.state == SessionState.END {
			add_high_score(&leaderboard, Score{"AAA", session.total_points})
			state = GameState.HIGH_SCORES
		}
	case GameState.HIGH_SCORES:
		update_high_scores(&leaderboard, input)
		// This impeccable if clause prevents the "select" button from changing the
		// game state if we instead want to advance the currently edited initial
		if (input.select.just_pressed && (leaderboard.current_score < 0 || leaderboard.current_score > 9 || leaderboard.current_initial > 2)) || input.quit.just_pressed {
			state = GameState.PRE_MAIN_MENU
			serialize_leaderboard(&leaderboard.data)
            stop_music(&sound_system)
		}
		draw_high_scores(&leaderboard, &config, &assets.fonts, platform, dt)
	case GameState.PRE_MAIN_MENU:
		update_pre_menu(game, input, platform, dt)
	case GameState.QUIT:
		platform.ready_to_quit = true
	}

    // Close to the shittest thing in this entire codebase
    if state == GameState.SESSION && session.state == SessionState.POST_LOSS && session.lives == 0 {
        update_sound_system(&sound_system, &platform.audio, dt * 0.9) 
    } else {
        update_sound_system(&sound_system, &platform.audio, dt)
    }
}
