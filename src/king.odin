package main
import "core:fmt"
import "core:math"
import "core:math/rand"

// King related things, particularly physical state, animation, and foods eaten.
King :: struct {
	jump_state: JumpState,
	position: Vec2,
	velocity: Vec2,
	gravity_scale: f32,

	foods_eaten: f32,
	jump_buffer: f32,
	coyote_time: f32,
	jump_gravity_countdown: f32,
	facing_right: bool,
	running_input: bool,

	animator: Animator,
	up_step: bool,
}

// Current state of the king's jump and float capabilities.
JumpState :: enum {
	GROUNDED,
	JUMP,
	FLOAT,
	POST_FLOAT,
}

// Initialize the starting values of king data.
init_king :: proc(king: ^King, data: ^LevelData, config: ^Config) {
	using king

	king.position = data.king_position

	gravity_scale = config.king_jump_gravity_scale
	jump_state = JumpState.GROUNDED
	facing_right = true
	running_input = false
	foods_eaten = 0
	velocity = {0, 0}
}

// Draw a sprite to the platform representative of the king's current state.
draw_king :: proc(king: ^King, y_offset: int, sequences: ^Sequences, platform: ^Platform, dt: f32) {
	using king

	animator.frame_length_mod = 1
	animator.sequence = &sequences.king_idle
	if running_input {
		animator.sequence = &sequences.king_run
		animator.frame_length_mod = 0.8
	}

	#partial switch(jump_state) {
	case JumpState.JUMP:
		animator.sequence = &sequences.king_jump
	case JumpState.FLOAT:
		animator.sequence = &sequences.king_float
	case JumpState.POST_FLOAT:
		animator.sequence = &sequences.king_post_float
	}

	animator.flipped = !facing_right

	king_position := ivec2_from_vec2(position)
	king_position.y += y_offset
	cycle_and_draw_animator(&animator, king_position, platform, dt)
}

// Accelerate in direction of input, or decelerate if input is zero.
update_king_movement :: proc(king: ^King, input: ^Input, config: ^Config, dt: f32) {
	using king

	running_input = false 
	acceleration_direction: f32 = 0
	if input.left.held {
		acceleration_direction -= 1 
		facing_right = false
		running_input = true
	} 
	if input.right.held {
		acceleration_direction += 1
		facing_right = true
		running_input = true
	}

	foods_eaten_mod := config.king_acceleration_scale_per_food
	i_foods_eaten: int = int(foods_eaten)
	for i: int = 0; i < i_foods_eaten; i += 1 {
		if i < 8 {
			foods_eaten_mod *= config.king_acceleration_scale_per_food
			continue
		}

		modded_scale := lerp(config.king_acceleration_scale_per_food, 1, (f32(i) - 8) / 8)
		if modded_scale > 1 {
			modded_scale = 1
		}
		foods_eaten_mod *= modded_scale
	}

	//foods_eaten_mod := math.pow(config.acceleration_scale_per_food, foods_eaten)
	acceleration_magnitude: f32 = config.king_base_acceleration * foods_eaten_mod * dt

	if jump_state == JumpState.GROUNDED && !running_input {
		if abs(velocity.x) - acceleration_magnitude < 0 {
			acceleration_direction = 0 // will cause a complete stop
		} else {
			acceleration_direction = -math.sign(velocity.x) 
		}
	}

	velocity.x += acceleration_direction * acceleration_magnitude
	velocity.x = clamp(velocity.x, -config.king_max_speed, config.king_max_speed)
}

// Updates king jump state from input, performing state machine functionality related to jumping.
update_king_jump_state :: proc(king: ^King, input: ^Input, config: ^Config, sound_system: ^SoundSystem, dt: f32) {
	using king

	if jump_state == JumpState.GROUNDED || coyote_time > 0 {
		coyote_time -= dt
		if input.jump.just_pressed || jump_buffer > 0 {
			jump_buffer = -1
			jump_state = JumpState.JUMP
			jump_gravity_countdown = config.king_jump_gravity_length
			velocity.y = -config.king_jump_velocity
			gravity_scale = config.king_jump_gravity_scale
			start_sound(sound_system, SoundType.JUMP)
		}
	} else if jump_state == JumpState.JUMP {
		gravity_scale = config.king_jump_gravity_scale_down

		if input.jump.just_pressed {
			jump_state = JumpState.FLOAT
			velocity.y = -config.king_float_velocity
			gravity_scale = config.king_float_initial_gravity_scale

			float_switchback_velocity: f32 = config.king_max_speed / 2
			if input.left.held && velocity.x > 0 {
				king.velocity.x = -float_switchback_velocity
			} else if input.right.held && velocity.x < 0 {
				king.velocity.x = float_switchback_velocity
			}

			start_sound(sound_system, SoundType.FLOAT)
		}
	} else if jump_state == JumpState.FLOAT || jump_state == JumpState.POST_FLOAT {
		gravity_scale = math.lerp(gravity_scale, config.king_float_target_gravity_scale, config.king_float_gravity_lerp_speed * dt)

		if jump_state == JumpState.FLOAT {
			sound_system.channels[0].sound.frequency += -velocity.y * 16 * dt
			if velocity.y > 0 {
				jump_state = JumpState.POST_FLOAT
				//start_sound(sound_system, SoundType.POST_FLOAT)
			}
		} else {
			sound_system.channels[0].sound.frequency -= -velocity.y * 2 * dt
		}

		jump_buffer -= dt
		if input.jump.just_pressed {
			jump_buffer = 0.1
		}
	}

	velocity.y += config.king_base_gravity * gravity_scale * dt
}

// Update the king's current position per his velocity and stop before a collision.
apply_king_velocity_and_crumble_tiles :: proc(king: ^King, tilemap: ^Tilemap, sound_system: ^SoundSystem, config: ^Config, dt: f32) -> int {
	using king
	effective_velocity: Vec2 = velocity

	collider := Rect{{-5, -16}, {10, 16}}

	x_off_col: Rect = collider
	x_off_col.position.x += velocity.x * dt * 1.1

	y_off_col: Rect = collider
	y_off_col.position.y += velocity.y * dt * 1.1

    all_off_col: Rect = collider
    all_off_col.position.x += velocity.x * dt * 1.1
    all_off_col.position.y += velocity.y * dt * 1.1

	ground_check_col: Rect = collider
	ground_check_col.position.y += 0.75

	is_grounded: bool = false

	tile_col: Rect = {{-8, 0}, {16, 10}}

	tile_to_crumble: int = -1
	closest_tile_distance: f32 = 128
	for tile, tile_index in tilemap {
		if tile.health == 0 {
			continue
		}

		tile_pos: Vec2 = tile_position_from_index(tile_index)

		if is_colliding(&x_off_col, &position, &tile_col, &tile_pos) {
            if effective_velocity.x > 0.000001 {
                all_off_col.position.x -= velocity.x * dt * 1.1
            }

			effective_velocity.x = 0
			velocity.x = 0
		}
	}

    for tile, tile_index in tilemap {
		if tile.health == 0 {
			continue
		}

		tile_pos: Vec2 = tile_position_from_index(tile_index)

        if is_colliding(&y_off_col, &position, &tile_col, &tile_pos) {
			effective_velocity.y = 0
            velocity.y = 0

			gravity_scale = config.king_fall_gravity_scale
		}
    }

    for tile, tile_index in tilemap {
		if tile.health == 0 {
			continue
		}

		tile_pos: Vec2 = tile_position_from_index(tile_index)

        if velocity.y >= 0 && is_colliding(&ground_check_col, &position, &tile_col, &tile_pos) {
			// TODO Should this disregard tiles that are currently crumbling to 0?
			distance := abs(position.x - tile_pos.x)
			if distance < closest_tile_distance {
				tile_to_crumble = tile_index
				closest_tile_distance = distance
			}

			if jump_state != JumpState.GROUNDED {
				//start_sound(sound_system, SoundType.LAND)
				up_step = false
				start_sound(sound_system, SoundType.DOWN_STEP)
				jump_state = JumpState.GROUNDED
			}

			is_grounded = true

		}
    }
	
	if !is_grounded && jump_state == JumpState.GROUNDED {
		jump_state = JumpState.JUMP
		coyote_time = 0.08
	}

	position += effective_velocity * dt

	return tile_to_crumble
}
