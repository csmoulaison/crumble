package main
import "core:math"

Session :: struct {
	state: SessionState,
	time_to_next_state: f32,

	// Sequence data
	tower_sequence: TowerSequence,
	current_tower: int,
	current_level: int,
	level_data: LevelData,

	// Overall session state
	total_points: int,
	lives: int,

	// Level state
	level_points: int,
	king: King,
	food: Food,
	enemy_list: EnemyList,
	tilemap: Tilemap,
	surface_map: SurfaceMap,
	scorepop: Scorepop,
	particle_system: ParticleSystem,
}

SessionState :: enum {
	WAITING_TO_START,
	LEVEL_ACTIVE,
	FOOD_RESET,
	HITCH,
	POST_WIN,
	POST_LOSS,
	PRE_LEVEL_SCREEN,
	PRE_SESSION_SCREEN,
	END,
	FINAL_SCREEN,
}

init_session :: proc(session: ^Session, config: ^Config) {
	using session

	deserialize_tower_sequence(&tower_sequence)

	current_tower = 0
	current_level = 0
	total_points = 0

	lives = config.level.starting_lives

	deserialize_level(&level_data, tower_sequence.towers[current_tower].levels[current_level])
	init_level(session, &level_data, config)
	init_fireworks(&particle_system)

	state = SessionState.PRE_LEVEL_SCREEN
	time_to_next_state = config.level.level_interstitial_length
}

handle_session :: proc(session: ^Session, input: ^Input, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> (ready_to_close: bool) {
	using session

	if input.editor_incr_lvl.just_pressed {
		try_advance_level(session, config)
		return false
	}

	#partial switch state {
	case SessionState.LEVEL_ACTIVE:
		state = handle_level_active(session, input, &level_data, config, sound_system, dt)

	case SessionState.WAITING_TO_START:
		time_to_next_state -= dt
		if time_to_next_state < 0 {
			time_to_next_state = 0
		}

		if input.jump.just_pressed {
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
			state = SessionState.LEVEL_ACTIVE
		}

	case SessionState.HITCH:
		time_to_next_state -= dt
		if time_to_next_state < 0 do state = SessionState.LEVEL_ACTIVE

	case SessionState.FOOD_RESET:
		state = handle_food_reset(session, config, sound_system, dt)
		
	case SessionState.POST_WIN:
		state = handle_post_win(session, config, dt)

	case SessionState.POST_LOSS:
		state = handle_post_loss(session, config, dt)

	case SessionState.PRE_LEVEL_SCREEN:
		time_to_next_state -= dt
		if time_to_next_state < 0 || input.jump.just_pressed {
			time_to_next_state = config.level.pre_active_length
			state = SessionState.WAITING_TO_START
		}

	case SessionState.PRE_SESSION_SCREEN:
		time_to_next_state -= dt
		if input.jump.just_pressed {
			time_to_next_state = config.level.level_interstitial_length
			state = SessionState.PRE_LEVEL_SCREEN
			start_sound(&sound_system.channels[0], SoundType.ENEMY_ALARMED)
		}

	case SessionState.FINAL_SCREEN:
		time_to_next_state -= dt * 0.5
		if time_to_next_state < 0 {
            update_fireworks(&particle_system, dt)
            if input.jump.just_pressed {
                state = SessionState.END
            }
		} else {
            if input.jump.just_pressed {
                time_to_next_state = 0
            }
        }
	}

	update_scorepop(&scorepop, dt)

	// Check for force exit
	if input.quit.just_pressed {
		state = SessionState.END
	}

	if state == SessionState.END do return true
	return false
}

draw_session :: proc(session: ^Session, assets: ^Assets, config: ^Config, sound_system: ^SoundSystem, platform: ^Platform, dt: f32) {
	using session

	if state == SessionState.HITCH || 
	state == SessionState.LEVEL_ACTIVE ||
   	state == SessionState.FOOD_RESET ||
   	state == SessionState.POST_WIN ||
   	state == SessionState.POST_LOSS {
		draw_level(session, true, assets, config, platform, dt)
		return
   	}

	if state == SessionState.FINAL_SCREEN {
        src: IRect = {{592,112},{16,16}}

        for i: int = 0; i < TILE_ROW_WIDTH; i += 1 {
            buffer_sprite(platform, src, IVec2{i * 16, LOGICAL_HEIGHT - 32}, IVec2{8,0}, false)
        }

        for i: int = 0; i < 10; i += 1 {
            buffer_sprite(platform, src, IVec2{10 * 16 + i * 16, LOGICAL_HEIGHT - 96}, IVec2{8,0}, false)
        }

        king_src_x: int = 112
        chef_src_x: int = 369
        if king.jump_state == JumpState.GROUNDED && time_to_next_state < 0 {
            if time_to_next_state + dt >= 0 {
                start_music(music_victory(), sound_system)
            }

            update_fireworks(&session.particle_system, dt)

            enemy_src_x: int = 192
            if int(time_to_next_state * 4) % 2 == 0 {
                chef_src_x += 17
                king_src_x -= 80
                enemy_src_x += 16
            }
            buffer_sprite(platform, IRect{{king_src_x, 16},{16,21}}, ivec2_from_vec2(king.position), IVec2{8,21}, false)

            buffer_sprite(platform, IRect{{412, 41},{13,11}}, IVec2{LOGICAL_WIDTH / 2 - 8, LOGICAL_HEIGHT - 128}, IVec2{6,5}, false)

            for i: int = 0; i < 4; i += 1 {
                flipped := false
                if i > 1 do flipped = true
                buffer_sprite(platform, IRect{{enemy_src_x, 16},{16, 21}}, IVec2{LOGICAL_WIDTH / 2 + i * 96 - 152, LOGICAL_HEIGHT - 32}, IVec2{8,21}, flipped)
            }

            draw_fireworks(&session.particle_system, platform)

            font := assets.fonts.red
            if int(time_to_next_state * 8) % 2 == 0 {
                font = assets.fonts.white
            }
            buffer_text(platform, {LOGICAL_WIDTH / 2 - 35, LOGICAL_HEIGHT - 196}, "The End", font)
        } else {
            if king.jump_state != JumpState.GROUNDED {
                king_y_offset: f32 = 0
                move_king_float_start(time_to_next_state, &king, &king_y_offset, config)
                draw_king(&king, int(king_y_offset), &assets.sequences, platform, dt)
            } else {
                buffer_sprite(platform, IRect{{king_src_x, 16},{16,21}}, ivec2_from_vec2(king.position), IVec2{8,21}, false)
            }

            for i: int = 0; i < 4; i += 1 {
                flipped := false
                if i > 1 do flipped = true
                buffer_sprite(platform, IRect{{224, 16},{16, 21}}, IVec2{LOGICAL_WIDTH / 2 + i * 96 - 152, LOGICAL_HEIGHT - 32}, IVec2{8,21}, flipped)
            }
        }

        buffer_sprite(platform, IRect{{chef_src_x, 32},{16,23}}, IVec2{LOGICAL_WIDTH / 2 + 8, LOGICAL_HEIGHT - 96}, IVec2{7,23}, false)

	}

	if state == SessionState.WAITING_TO_START {
        king_y_offset: f32 = 0
        move_king_float_start(time_to_next_state, &king, &king_y_offset, config)
        draw_level(session, false, assets, config, platform, dt)
		draw_king(&king, int(king_y_offset), &assets.sequences, platform, dt)
		return
   }

   if state == SessionState.PRE_LEVEL_SCREEN {
		draw_level_interstitial(session, time_to_next_state, assets, platform, dt)
		return
   }

   if state == SessionState.PRE_SESSION_SCREEN {
		draw_pre_session_screen(session, assets, platform, time_to_next_state)
		return
   }
}

@(private="file")
handle_level_active:: proc(session: ^Session, input: ^Input, data: ^LevelData, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> SessionState {
	using session

	interpret_surfaces(&tilemap, &surface_map, &enemy_list, king.position)

	for &enemy in enemy_list.enemies[:enemy_list.len] {
		update_enemy(&enemy, &king, &surface_map, &config.enemy, sound_system, dt)
	}

	update_tile_crumble(&tilemap, dt)

	update_king_movement(&king, input, &config.king, dt)
	update_king_jump_state(&king, input, &config.king, sound_system, dt)

	physics_iterations: int = 1
	for i: int = 0; i < physics_iterations - 1; i += 1 {
		//apply_king_velocity_and_crumble_tiles(&king, &tilemap, &config.king, &config.tile, dt / f32(physics_iterations))
	}

	tile_to_crumble: int = apply_king_velocity_and_crumble_tiles(&king, &tilemap, &config.king, &config.tile, dt / f32(physics_iterations))
	// Crumble the closest tile if there is one
	if tile_to_crumble != -1 && !tilemap[tile_to_crumble].is_crumbling {
		tile := &tilemap[tile_to_crumble]
		tile.is_crumbling = true
		tile.time_till_crumble = config.tile.crumble_tile_length
	}


	update_food_eating(&food, &king, session, sound_system, &config.food)
	update_food_state(&food, &config.food, sound_system, dt)
	update_pot_bounce(&food, &king, session, sound_system, &config.level)
	
	// Check lose state
	is_king_out_of_bounds := king.position.y > LOGICAL_HEIGHT + 96
	if is_king_out_of_bounds || check_king_caught(&enemy_list, &king) {
		stop_music(sound_system)

        if lives == 0 {
            start_sound(&sound_system.channels[0], SoundType.GAME_OVER)
            time_to_next_state = 9
        } else {
            start_sound(&sound_system.channels[0], SoundType.KING_DIE)
            time_to_next_state = config.level.post_loss_length
        }
		return SessionState.POST_LOSS
	}

	return state
}

@(private="file")
handle_food_reset :: proc(session: ^Session, config: ^Config, sound_system: ^SoundSystem, dt: f32) -> SessionState {
	using session.food

	time_to_blink_toggle -= dt
	if time_to_blink_toggle < 0 {
        start_sound(&sound_system.channels[0], SoundType.JUMP)
		is_blinking = !is_blinking
		time_to_blink_toggle = config.food.blink_length
            king_src_x: int = 112
	}

	session.time_to_next_state -= dt
	if session.time_to_next_state < 0 {
		for &active_window, i in active_windows[:windows_len] {
			windows[i].is_active = true // TODO: is_active redundant?
			active_window = i
		}
		active_windows_len = windows_len
		start_food_cycle(&session.food, &config.food)
		start_sound(&sound_system.channels[0], SoundType.ENEMY_ALARMED)
		return SessionState.LEVEL_ACTIVE
	}

	return session.state
}

@(private="file")
handle_post_win :: proc(session: ^Session, config: ^Config, dt: f32) -> SessionState {
	using session

	king.position.y -= config.king.pot_bounce_speed * dt

	time_to_next_state -= dt
	if time_to_next_state < 0 {
		next_level_exists, tower_end := try_advance_level(session, config)

		if !next_level_exists {
            king.position = {LOGICAL_WIDTH / 2 - 24, LOGICAL_HEIGHT - 96};
            king.facing_right = true
            king.velocity = Vec2{0, 0}
			time_to_next_state = config.level.pre_active_length
            return SessionState.FINAL_SCREEN
        }

		time_to_next_state = config.level.level_interstitial_length
		return SessionState.PRE_LEVEL_SCREEN
	}

	return state
}

@(private="file")
handle_post_loss :: proc(session: ^Session, config: ^Config, dt: f32) -> SessionState {
	using session

	time_to_next_state -= dt * 3
	if time_to_next_state < 0 {
		lives -= 1
		if lives < 0 {
			return SessionState.END
		}
		else {
			init_level(session, &level_data, config)
			return SessionState.WAITING_TO_START
		}
	}

	return state
}

/* Tries to advance and initialize level, returning false if associated file
isn't found or if sequence is over. Also adds level points to total points.*/
@(private="file")
try_advance_level :: proc(session: ^Session, config: ^Config) -> (next_level_exists: bool, tower_end: bool) {
	using session

	total_points += level_points

	current_level += 1
	if current_level >= tower_sequence.towers[current_tower].len {
		//current_level = 0
		//current_tower += 1
		//tower_end = true
		//if current_tower >= TOWER_COUNT {
			return false, false
		//}
	}

	ok := deserialize_level(&level_data, tower_sequence.towers[current_tower].levels[current_level])
	if !ok {
		current_tower -= 1
		return false, false
	}

	init_level(session, &level_data, config)
	return true, tower_end
}
