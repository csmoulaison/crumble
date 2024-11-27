package main

handle_waiting_to_start :: proc(session: ^Session, input: ^Input, sound_system: ^SoundSystem, dt: f32) {
	session.time_to_next_state -= dt
	if session.time_to_next_state < 0 {
		session.time_to_next_state = 0
	}

	if !input.jump.just_pressed {
		return
	}

	// Just pressed start button
	switch session.current_level {
		case 0:
			start_music(music_speed(), sound_system)
		case 1:
			start_music(music_speed(), sound_system)
		case 2:
			start_music(music_bach1041(), sound_system)
		case 3:
			start_music(music_speed(), sound_system)
		case 4:
			start_music(music_greensleeves(), sound_system)
		case 5:
			start_music(music_islands(), sound_system)
	}
	session.state = SessionState.LEVEL_ACTIVE
}
