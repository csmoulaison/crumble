package main
import "core:fmt"
import "core:math"
import "core:math/rand"

draw_builder :: proc(builder: ^King, y_offset: int, sequences: ^Sequences, platform: ^Platform, dt: f32) {
	using builder

	animator.frame_length_mod = 1
	animator.sequence = &sequences.builder_idle
	if running_input {
		animator.sequence = &sequences.builder_run
		animator.frame_length_mod = 0.8
	}

	#partial switch(jump_state) {
	case JumpState.JUMP:
		animator.sequence = &sequences.builder_jump
	case JumpState.FLOAT:
		animator.sequence = &sequences.builder_float
	}

	animator.flipped = !facing_right

	builder_position := ivec2_from_vec2(position)
	builder_position.y += y_offset
	cycle_and_draw_animator(&animator, builder_position, platform, dt)
}

update_builder_movement :: proc(builder: ^King, input: ^Input, config: ^Config, dt: f32) {
	using builder

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

update_builder_jump_state:: proc(builder: ^King, mod_low_grav: bool, input: ^Input, config: ^Config, sound_system: ^SoundSystem, dt: f32) {
	using builder

	if jump_state == JumpState.GROUNDED || coyote_time > 0 {
		coyote_time -= dt
		if input.jump.just_pressed || jump_buffer > 0 {
			jump_buffer = -1
			jump_state = JumpState.JUMP
			jump_gravity_countdown = config.king_jump_gravity_length
			velocity.y = -config.king_jump_velocity * 1.4
			gravity_scale = config.king_jump_gravity_scale
			start_sound(sound_system, SoundType.FLOAT)

			if input.left.held {
				velocity.x = -config.king_max_speed
			} else if input.right.held {
				velocity.x = config.king_max_speed
			}

		}
	} else if jump_state == JumpState.JUMP {
		gravity_scale = config.king_jump_gravity_scale_down
		sound_system.channels[0].sound.frequency += -velocity.y * 16 * dt

		if input.jump.just_pressed {
			jump_state = JumpState.FLOAT
			velocity.y = -config.king_jump_velocity * 1
			start_sound(sound_system, SoundType.JUMP)

			float_switchback_velocity: f32 = config.king_max_speed / 2
			if input.left.held && velocity.x > 0 {
				builder.velocity.x = -float_switchback_velocity
			} else if input.right.held && velocity.x < 0 {
				builder.velocity.x = float_switchback_velocity
			}
		}
	} else if jump_state == JumpState.FLOAT {
		gravity_scale = config.king_jump_gravity_scale_down
	}

	velocity.y += config.king_base_gravity * gravity_scale * dt
}
