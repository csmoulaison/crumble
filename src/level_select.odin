package main
import "core:strings"

LEVEL_COUNT :: 8

LevelSelectMenu :: struct {
	choice_sin_amps: [LEVEL_COUNT]f32,
	sin_t: f32,
	highlighted_choice: int,
}

init_level_select :: proc(level_select: ^LevelSelectMenu) {
	using level_select
	highlighted_choice = 0
}

draw_level_select :: proc(level_select: ^LevelSelectMenu, assets: ^Assets, platform: ^Platform, dt: f32) {
	using level_select

	// For wavy text
	sin_frequency: f32 = 14
	sin_t += sin_frequency * dt
	sin_highlighted_amp: f32 = 1.5
	sin_amp_speed: f32 = 10

	font := assets.fonts.white

	for i: int = 0; i < LEVEL_COUNT; i += 1 {
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

		level_str := strings.builder_make()
		strings.write_string(&level_str, "Level ")
		strings.write_int(&level_str, i)

		buffer_text_ext(
			platform, 
			{LOGICAL_WIDTH / 2 - 7 * 7 / 2, 128 + i * 32}, 
			strings.to_string(level_str), 
			font,
			choice_sin_amps[i],
			sin_t)
	}
}

handle_level_select :: proc(game: ^Game, level_select: ^LevelSelectMenu, input: ^Input, sound_system: ^SoundSystem) -> GameState {
	using level_select

	if input.up.just_pressed {
		highlighted_choice -= 1
		if highlighted_choice < 0 do highlighted_choice = MAIN_MENU_CHOICE_LEN - 1
		start_sound(&sound_system.channels[0], SoundType.NAVIGATE)
	}
	if input.down.just_pressed {
		highlighted_choice += 1
		if highlighted_choice > MAIN_MENU_CHOICE_LEN - 1 do highlighted_choice = 0
		start_sound(&sound_system.channels[0], SoundType.NAVIGATE)
	}

	// Check for application force quit
	if input.quit.just_pressed {
		return GameState.QUIT
	}

	// Control menu selection
	if input.select.just_pressed {
		start_sound(&sound_system.channels[0], SoundType.SELECT)
	}

	return GameState.MAIN_MENU	
}
