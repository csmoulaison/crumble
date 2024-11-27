package main

handle_post_loss :: proc(session: ^Session, config: ^Config, dt: f32) -> SessionState {
	using session

	time_to_next_state -= dt * 3
	if time_to_next_state < 0 {
		lives -= 1
		if lives < 0 {
			return SessionState.END
		} else {
			init_level(session, &level_data, config)
			return SessionState.WAITING_TO_START
		}
	}

	return state
}
