package main
import "core:fmt"
import "core:strings"

MAIN_MENU_CHOICE_LEN :: 5
START_GAME_TEXT :: "Start Game"
LEADERBOARD_TEXT :: "High scores"
QUIT_TEXT :: "QUIT"
LEVEL_EDITOR_TEXT :: "Level Editor"
TOWER_EDITOR_TEXT :: "Tower Editor"

MainMenu :: struct {
	choices: [MAIN_MENU_CHOICE_LEN]string,
	choice_sin_amps: [MAIN_MENU_CHOICE_LEN]f32,
	sin_t: f32,
	highlighted_choice: int,
}

init_main_menu :: proc(main_menu: ^MainMenu) {
	using main_menu

	choices = {START_GAME_TEXT, LEVEL_EDITOR_TEXT, TOWER_EDITOR_TEXT, LEADERBOARD_TEXT, QUIT_TEXT}
}

handle_main_menu :: proc(game: ^Game, main_menu: ^MainMenu, input: ^Input, sound_system: ^SoundSystem) {
	using main_menu

	if input.up.just_pressed {
		highlighted_choice -= 1
		if highlighted_choice < 0 do highlighted_choice = MAIN_MENU_CHOICE_LEN - 1
		start_sound(sound_system, SoundType.NAVIGATE)
	}
	if input.down.just_pressed {
		highlighted_choice += 1
		if highlighted_choice > MAIN_MENU_CHOICE_LEN - 1 do highlighted_choice = 0
		start_sound(sound_system, SoundType.NAVIGATE)
	}

	// Check for application force quit
	if input.quit.just_pressed {
		game.state = GameState.QUIT
		return
	}

	// Control menu selection
	if input.select.just_pressed {
		start_sound(sound_system, SoundType.SELECT)

		switch choices[highlighted_choice] {
		case START_GAME_TEXT:
			init_session(&game.session, &game.config)
			stop_music(sound_system)
			game.state = GameState.SESSION
		case LEADERBOARD_TEXT:
			game.leaderboard.current_score = -1
			game.state = GameState.HIGH_SCORES
		case LEVEL_EDITOR_TEXT:
			//init_editor(&game.editor)
			//game.state = GameState.EDITOR
		case TOWER_EDITOR_TEXT:
			//init_tower_editor(&game.tower_editor)
			//game.state = GameState.TOWER_EDITOR
		case QUIT_TEXT:
			game.state = GameState.QUIT
		}
		return
	}
}

draw_main_menu :: proc(main_menu: ^MainMenu, assets: ^Assets, platform: ^Platform, dt: f32) {
	using main_menu

	// For wavy text
	sin_frequency: f32 = 14
	sin_t += sin_frequency * dt
	sin_highlighted_amp: f32 = 1.5
	sin_amp_speed: f32 = 10

	font := assets.fonts.white

	title: string = "Crumble King"
	buffer_text(
		platform, 
		{LOGICAL_WIDTH / 2 - len(title) * 7 / 2, 64}, 
		title, 
		font)

	for choice, i in choices[:MAIN_MENU_CHOICE_LEN] {
		font = assets.fonts.white
		if i == highlighted_choice {
			choice_sin_amps[i] += sin_amp_speed * dt
			if choice_sin_amps[i] > sin_highlighted_amp {
				choice_sin_amps[i] = sin_highlighted_amp
			}

			font = assets.fonts.red
		} else {
			choice_sin_amps[i] -= sin_amp_speed * 0.25 * dt
			if choice_sin_amps[i] < 0 {
				choice_sin_amps[i] = 0
			}
		}

		buffer_text_ext(
			platform, 
			{LOGICAL_WIDTH / 2 - len(choice) * 7 / 2, 128 + i * 32}, 
			choice, 
			font,
			choice_sin_amps[i],
			sin_t)
	}
}
