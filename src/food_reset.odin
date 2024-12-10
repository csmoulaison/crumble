package main

handle_food_reset :: proc(session: ^Session, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> SessionState {
	using session.food

	time_to_blink_toggle -= dt
	if time_to_blink_toggle < 0 {
        start_sound(sound_system, SoundType.JUMP)
		is_blinking = !is_blinking
		time_to_blink_toggle = config.food_blink_length
            king_src_x: int = 112
	}

	session.time_to_next_state -= dt
	if session.time_to_next_state < 0 {
		for &active_window, i in active_windows[:windows_len] {
			windows[i].is_active = true // TODO: is_active redundant?
			active_window = i
		}
		active_windows_len = windows_len
		start_food_cycle(&session.food, config)
		start_sound(sound_system, SoundType.ENEMY_ALARMED)
		start_music(session.current_level, sound_system)
		return SessionState.LEVEL_ACTIVE
	}

	return session.state
}
