package main

handle_level_active:: proc(session: ^Session, input: ^Input, data: ^LevelData, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> SessionState {
	using session

	interpret_surfaces(&tilemap, &surface_map, &enemy_list, king.position)

	for &enemy in enemy_list.enemies[:enemy_list.len] {
		update_enemy(&enemy, &king, &surface_map, config, sound_system, dt)
	}

	update_tile_crumble(&tilemap, dt)

	update_king_movement(&king, input, config, dt)
	update_king_jump_state(&king, input, config, sound_system, dt)

	physics_iterations: int = 1
	for i: int = 0; i < physics_iterations - 1; i += 1 {
		//apply_king_velocity_and_crumble_tiles(&king, &tilemap, &config.king, &config.tile, dt / f32(physics_iterations))
	}

	tile_to_crumble: int = apply_king_velocity_and_crumble_tiles(&king, &tilemap, config, dt / f32(physics_iterations))
	// Crumble the closest tile if there is one
	if tile_to_crumble != -1 && !tilemap[tile_to_crumble].is_crumbling {
		tile := &tilemap[tile_to_crumble]
		tile.is_crumbling = true
		tile.time_till_crumble = config.tile_crumble_length
	}


	update_food_eating(&food, &king, session, sound_system, config)
	update_food_state(&food, config, sound_system, dt)
	update_pot_bounce(&food, &king, session, sound_system, config)
	
	// Check lose state
	is_king_out_of_bounds := king.position.y > LOGICAL_HEIGHT + 96
	if is_king_out_of_bounds || check_king_caught(&enemy_list, &king) {
		stop_music(sound_system)

        if lives == 0 {
            start_sound(&sound_system.channels[0], SoundType.GAME_OVER)
            time_to_next_state = 9
        } else {
            start_sound(&sound_system.channels[0], SoundType.KING_DIE)
            time_to_next_state = config.post_loss_length
        }
		return SessionState.POST_LOSS
	}

	return state
}
