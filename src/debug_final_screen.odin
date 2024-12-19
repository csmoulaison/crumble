package main

debug_final_screen :: proc(game: ^Game, config: ^Config) {
	using game.session

    king.position = {LOGICAL_WIDTH / 2 - 24, LOGICAL_HEIGHT - 96};
    king.facing_right = true
    king.velocity = Vec2{0, 0}
    king.jump_state = JumpState.FLOAT
	time_to_next_state = config.pre_active_length
	state = SessionState.FINAL_SCREEN
}
