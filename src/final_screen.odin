package main

handle_final_screen :: proc(session: ^Session, input: ^Input, dt: f32) {
	using session

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

draw_final_screen :: proc(session: ^Session, assets: ^Assets, config: ^Config, sound_system: ^SoundSystem, platform: ^Platform, dt:f32) {
	using session

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
            start_music(6, sound_system)
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
