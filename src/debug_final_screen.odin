package main

debug_final_screen :: proc(game: ^Game, config: ^Config) {
	using game.session

	mod_crumbled = true
	king.character = Character.CHEF
    king.position = {LOGICAL_WIDTH / 2 - 24, LOGICAL_HEIGHT - 96};
    king.facing_right = true
    king.velocity = Vec2{0, 0}
	time_to_next_state = config.pre_active_length
	state = SessionState.FINAL_SCREEN
}
