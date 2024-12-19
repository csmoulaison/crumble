package main
import "core:fmt"
import "core:os"

secret_code_len :: 8

GameState :: enum {
	STARTUP,
	SESSION,
	HIGH_SCORES,
	PRE_MAIN_MENU,
	QUIT,
}

ModSpeedState :: enum {
	NORMAL,
	SLOW,
	FAST,
}

Game :: struct {
	state: GameState,
	assets: Assets,
	config: Config,

	// State specific data
	session: Session,
	leaderboard: Leaderboard,
	sound_system: SoundSystem,
	intro_elapsed_time: f32,
	secret_code_inputs: [secret_code_len]int,

	// UI state
	premenu_cycle_index: int,
	premenu_cycle_bang: bool,
}

init_game :: proc(game: ^Game, platform: ^Platform) {
	using game

	load_assets(&assets, platform)
	deserialize_leaderboard(leaderboard_fname(&game.session), &leaderboard.data)

	init_config(&game.config)
	init_sound_system(&game.sound_system)

	state = GameState.STARTUP
}

update_game :: proc(game: ^Game, input: ^Input, platform: ^Platform, dt: f32) {
	using game

	switch state {
	case GameState.STARTUP:
		intro_elapsed_time += dt
		if intro_elapsed_time > 0.25 {
			start_sound(&sound_system, SoundType.STARTUP)
			state = GameState.PRE_MAIN_MENU
			intro_elapsed_time = 0
		}
	case GameState.SESSION:
		handle_session(&session, input, &config, &sound_system, dt)
		draw_session(&session, &assets, &config, &sound_system, platform, dt)

		if session.state == SessionState.END {
			if platform.mod_glitchy {
				os.exit(0)
			}
			
			add_high_score(game, Score{"AAA", session.total_points})
			state = GameState.HIGH_SCORES
		}
	case GameState.HIGH_SCORES:
		update_high_scores(game, input)
		draw_high_scores(game, &config, platform, dt)
	case GameState.PRE_MAIN_MENU:
		update_pre_menu(game, input, platform, dt)
	case GameState.QUIT:
		platform.ready_to_quit = true
	}

    // Close to the shittest thing in this entire codebase
    if state == GameState.SESSION && session.state == SessionState.POST_LOSS && session.lives == 0 {
        update_sound_system(&sound_system, &platform.audio, session.food.round, dt * 0.9) 
    } else {
        update_sound_system(&sound_system, &platform.audio, session.food.round, dt)
    }
}
