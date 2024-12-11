package main
import "core:fmt"
import "core:math"
import "core:math/rand"

draw_chef :: proc(chef: ^King, y_offset: int, sequences: ^Sequences, platform: ^Platform, dt: f32) {
	using chef

	animator.frame_length_mod = 1
	animator.sequence = &sequences.chef_idle
	if running_input {
		animator.sequence = &sequences.chef_run
		animator.frame_length_mod = 0.8
	}

	#partial switch(jump_state) {
	case JumpState.JUMP:
		animator.sequence = &sequences.chef_jump
	case JumpState.FLOAT:
		animator.sequence = &sequences.chef_float

		velocity_frame_mod: f32 = math.abs(chef.velocity.y) + 50
		animator.frame_length_mod = 50 / velocity_frame_mod
		if animator.frame_length_mod > 2 {
			animator.frame_length_mod = 2
		}
	case JumpState.POST_FLOAT:
		animator.sequence = &sequences.chef_float
		animator.frame_length_mod = lerp(animator.frame_length_mod, 1, dt * 2)
	}

	animator.flipped = !facing_right

	chef_position := ivec2_from_vec2(position)
	chef_position.y += y_offset
	cycle_and_draw_animator(&animator, chef_position, platform, dt)
}

update_chef_movement :: proc(chef: ^King, input: ^Input, config: ^Config, dt: f32) {
	using chef

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

	if jump_state == JumpState.FLOAT {
		acceleration_magnitude /= 2
	}

	velocity.x += acceleration_direction * acceleration_magnitude
	velocity.x = clamp(velocity.x, -config.king_max_speed, config.king_max_speed)
}

update_chef_jump_state:: proc(chef: ^King, mod_low_grav: bool, input: ^Input, config: ^Config, sound_system: ^SoundSystem, dt: f32) {
	using chef

	if jump_state == JumpState.GROUNDED || coyote_time > 0 {
		coyote_time -= dt
		if input.jump.just_pressed || jump_buffer > 0 {
			jump_buffer = -1
			jump_state = JumpState.JUMP
			jump_gravity_countdown = config.king_jump_gravity_length
			velocity.y = -config.king_jump_velocity * 0.7
			gravity_scale = config.king_jump_gravity_scale
			start_sound(sound_system, SoundType.JUMP)
		}
	} else if jump_state == JumpState.JUMP {
		gravity_scale = config.king_jump_gravity_scale_down

		if input.jump.just_pressed {
			jump_state = JumpState.FLOAT
			gravity_scale = 0
			jump_gravity_countdown = 0.5

			float_switchback_velocity: f32 = config.king_max_speed / 2
			if input.left.held && velocity.x > 0 {
				velocity.x = -float_switchback_velocity
			} else if input.right.held && velocity.x < 0 {
				velocity.x = float_switchback_velocity
			}

			start_sound(sound_system, SoundType.FLOAT)
		}
	} else if jump_state == JumpState.FLOAT {
		velocity.y -= 600 * dt

		jump_gravity_countdown -= dt
		if jump_gravity_countdown < 0 || input.jump.just_released {
			jump_state = JumpState.POST_FLOAT
			gravity_scale = config.king_fall_gravity_scale
		}

		if input.jump.just_released {
			jump_state = JumpState.POST_FLOAT
			gravity_scale = config.king_fall_gravity_scale
		}
	
		if jump_state == JumpState.FLOAT {
			sound_system.channels[0].sound.frequency += -velocity.y * 16 * dt
		} else {
			sound_system.channels[0].sound.frequency -= -velocity.y * 2 * dt
		}

		jump_buffer -= dt
		if input.jump.just_pressed {
			jump_buffer = 0.1
		}
	} if jump_state == JumpState.POST_FLOAT {
		gravity_scale = config.king_fall_gravity_scale
	}

	velocity.y += config.king_base_gravity * gravity_scale * dt
}
