package main
import "core:fmt"

handle_final_screen :: proc(session: ^Session, input: ^Input, dt: f32) {
	using session

	if time_to_next_state < 0 {
		time_to_next_state -= dt * 0.5
		update_fireworks(&particle_system, dt)
		if input.jump.just_pressed {
		    state = SessionState.END
		}
	} else {
		time_to_next_state -= dt * 0.33
		if input.jump.just_pressed {
		    time_to_next_state = 0
		}
	}
}

draw_final_screen :: proc(session: ^Session, assets: ^Assets, config: ^Config, sound_system: ^SoundSystem, platform: ^Platform, dt:f32) {
	using session

	platform.logical_offset.x = 88
	platform.logical_offset.y = -120
	platform.logical_offset_active = true

    src: IRect = {{272,80},{16,16}}

    for i: int = 0; i < TILE_ROW_WIDTH; i += 1 {
        buffer_sprite(platform, src, IVec2{i * 16, LOGICAL_HEIGHT - 32}, IVec2{8,0}, false)
    }

    for i: int = 0; i < 10; i += 1 {
        buffer_sprite(platform, src, IVec2{10 * 16 + i * 16, LOGICAL_HEIGHT - 96}, IVec2{8,0}, false)
    }

	// Get the proper sprites associated with each character in the final cinematic
	platform.logical_offset.x = 8

	// Cache the current character, because we might change it later to use
	// the draw_king function to intended effect
    cached_character: Character = king.character

	king_spr_1: IRect = {{112, 0}, {16, 21}}
	king_spr_2: IRect = {{32, 0}, {16, 21}}
	chef_spr_1: IRect = {{144, 105}, {16, 21}}
	chef_spr_2: IRect = {{160, 105}, {16, 21}}
	enemy_spr_1: IRect = {{32, 231}, {16, 21}}
	enemy_spr_2: IRect = {{16, 231}, {16, 21}}

	// The food hint being done is a somewhat special case so has its own branch
	if food_hint_accomplished {
		builder_spr_1: IRect = {{112, 168}, {16, 21}}
		builder_spr_2: IRect = {{96, 168}, {16, 21}}

		#partial switch cached_character {
		case Character.CHEF:
			king_spr_1 = chef_spr_1
			king_spr_2 = chef_spr_2
		case Character.BUILDER:
			king_spr_1 = builder_spr_1
			king_spr_2 = builder_spr_2
		}

		#partial switch king.skin {
		case Skin.ALT_ONE:
			king_spr_1.position.y += 21
			king_spr_2.position.y += 21
		case Skin.ALT_TWO:
			king_spr_1.position.y += 42
			king_spr_2.position.y += 42
		case Skin.CROWN_KING:
			king_spr_1.position.y += 63
			king_spr_2.position.y += 63
		}

		chef_spr_1 = builder_spr_1
		chef_spr_2 = builder_spr_2
	// General cases, separated into each player character case
	} else if cached_character == Character.KING {
		#partial switch king.skin {
		case Skin.ALT_ONE:
			king_spr_1.position.y = 21
			king_spr_2.position.y = 21
		case Skin.ALT_TWO:
			king_spr_1.position.y = 42
			king_spr_2.position.y = 42
		case Skin.CROWN_KING:
			king_spr_1.position.y = 63
			king_spr_2.position.y = 63
		}
	} else if cached_character == Character.CHEF {
		king.character = Character.KING

		#partial switch king.skin {
		case Skin.ALT_ONE:
			chef_spr_1.position.y = 126
			chef_spr_2.position.y = 126
		case Skin.ALT_TWO:
			chef_spr_1.position.y = 147
			chef_spr_2.position.y = 147
		}
	} else if cached_character == Character.BUILDER {
		chef_spr_1.position.y = -21
		chef_spr_2.position.y = -21

		#partial switch king.skin {
		case Skin.DEFAULT:
			king_spr_1.position.y = 168
			king_spr_2.position.y = 168
		case Skin.ALT_ONE:
			king_spr_1.position.y = 189
			king_spr_2.position.y = 189
		case Skin.ALT_TWO:
			king_spr_1.position.y = 210
			king_spr_2.position.y = 210
		}
	}

	king_spr_cur: IRect = king_spr_1
	chef_spr_cur: IRect = chef_spr_1
	enemy_spr_cur: IRect = enemy_spr_1
	enemy_spr_pre: IRect = {{64, 231}, {16, 21}}

    // Actual drawing is split into two cases, the first being after the king
    // has floated in, with the "The End" text and all, and the second being as
    // the King is floating into place.
    if king.jump_state == JumpState.GROUNDED && time_to_next_state < 0 {
	    // Check if we were in the previous case last frame, triggering music if so
        if time_to_next_state + dt >= 0 {
            start_music(6, sound_system)
        }

		// Alternate between the two frames for each character on screen
        if int(time_to_next_state * 4) % 2 == 0 {
	        king_spr_cur = king_spr_2
			chef_spr_cur = chef_spr_2
			enemy_spr_cur = enemy_spr_2
        }

		// Draw king
        buffer_sprite(platform, king_spr_cur, ivec2_from_vec2(king.position), IVec2{8,21}, false)

        // Draw heart
        buffer_sprite(platform, IRect{{160, 209},{13,11}}, IVec2{LOGICAL_WIDTH / 2 - 8, LOGICAL_HEIGHT - 128}, IVec2{6,5}, false)

		// Draw enemies
        for i: int = 0; i < 4; i += 1 {
            flipped := false
            if i > 1 {
	            flipped = true
            }
            buffer_sprite(platform, enemy_spr_cur, IVec2{LOGICAL_WIDTH / 2 + i * 96 - 152, LOGICAL_HEIGHT - 32}, IVec2{8,21}, flipped)
        }

		// Draw end titles
		platform.logical_offset_active = false
		end_titles: IRect = {{176, 190}, {62, 16}}
		buffer_sprite(platform, end_titles, IVec2{LOGICAL_WIDTH / 2, LOGICAL_HEIGHT / 2 - 44}, IVec2{31, 8}, false)
		platform.logical_offset_active = true

		// And fireworks!
        update_fireworks(&session.particle_system, dt)
		draw_fireworks(&session.particle_system, platform)
	// The case where the king is still floating into place
    } else {
	    // Draw king
        if king.jump_state != JumpState.GROUNDED {
            king_y_offset: f32 = 0
            move_king_float_start(time_to_next_state, &king, &king_y_offset, config)
            draw_king(&king, int(king_y_offset), &session.king_sequences, platform, dt)
        } else {
            buffer_sprite(platform, king_spr_1, ivec2_from_vec2(king.position), IVec2{8,21}, false)
        }

		// Draw enemies
        for i: int = 0; i < 4; i += 1 {
            flipped := false
            if i > 1 do flipped = true
            buffer_sprite(platform, enemy_spr_pre, IVec2{LOGICAL_WIDTH / 2 + i * 96 - 152, LOGICAL_HEIGHT - 32}, IVec2{8,21}, flipped)
        }
    }

	// Draw chef
    buffer_sprite(platform, chef_spr_cur, IVec2{LOGICAL_WIDTH / 2 + 8, LOGICAL_HEIGHT - 96}, IVec2{7,21}, true)

	// The character must be restored so that high scores will function correctly
    session.king.character = cached_character

	platform.logical_offset_active = false
	draw_codes(session, platform)
	platform.logical_offset_active = true
}	

