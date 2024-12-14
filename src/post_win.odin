package main

handle_post_win :: proc(session: ^Session, config: ^Config, dt: f32) -> SessionState {
	using session

	king.position.y -= config.king_pot_bounce_speed * dt

	time_to_next_state -= dt
	if time_to_next_state < 0 {
		next_level_exists, tower_end := try_advance_level(session, config)

		if !next_level_exists || food_hint_accomplished {
            king.position = {LOGICAL_WIDTH / 2 - 24, LOGICAL_HEIGHT - 96};
            king.facing_right = true
            king.velocity = Vec2{0, 0}
			time_to_next_state = config.pre_active_length
            return SessionState.FINAL_SCREEN
        }

		time_to_next_state = config.level_interstitial_length
		return SessionState.PRE_LEVEL_SCREEN
	}

	return state
}
