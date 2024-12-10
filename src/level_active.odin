package main

handle_level_active:: proc(session: ^Session, input: ^Input, data: ^LevelData, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> SessionState {
	using session

	interpret_surfaces(&tilemap, &surface_map, &enemy_list, king.position)

	for &enemy in enemy_list.enemies[:enemy_list.len] {
		update_enemy(&enemy, &king, &surface_map, config, sound_system, dt)
	}

	update_tile_crumble(&tilemap, config, dt)

	update_king_movement(&king, input, config, dt)
	update_king_jump_state(&king, input, config, sound_system, dt)

	tile_to_crumble: int = apply_king_velocity_and_crumble_tiles(&king, &tilemap, sound_system, config, dt)
	// Crumble the closest tile if there is one
	if tile_to_crumble != -1 && !tilemap[tile_to_crumble].is_crumbling {
		tile := &tilemap[tile_to_crumble]

		if king.character != Character.BUILDER {
			tile.is_crumbling = true
			tile.time_till_crumble = config.tile_crumble_length
		} else {
			tile.is_crumbling = false
			tile.time_till_crumble = config.tile_degrade_length
			if tile.health > 0 && tile.health < MAX_TILE_HEALTH {
				tile.health += 1
			}
		}
	}

	if king.character == Character.BUILDER {
		update_tile_degrade(&tilemap, config, dt)
	}

	if (input.left.held || input.right.held) && king.animator.just_advanced_frame && king.jump_state == JumpState.GROUNDED {
		king.up_step = !king.up_step
		if(king.up_step) {
			start_sound(sound_system, SoundType.UP_STEP)
		} else {
			start_sound(sound_system, SoundType.DOWN_STEP)
		}
	}

	update_food_eating(&food, &king, session, sound_system, config)
	update_food_state(&food, config, sound_system, dt)
	update_pot_bounce(&food, &king, session, sound_system, config)
	
	// Check lose state
	is_king_out_of_bounds := king.position.y > LOGICAL_HEIGHT + 96
	if is_king_out_of_bounds || check_king_caught(&enemy_list, &king, sound_system) {
		stop_music(sound_system)

        if lives == 0 {
            start_sound(sound_system, SoundType.GAME_OVER)
            time_to_next_state = 9
        } else {
            start_sound(sound_system, SoundType.KING_DIE)
            time_to_next_state = config.post_loss_length
        }
		return SessionState.POST_LOSS
	}

	return state
}
