// TODO bug test enemy seeing king behavior
package main
import "core:fmt"
import "core:math"
import "core:math/rand"

MAX_ENEMIES :: 16

EnemyState :: enum {
	PAUSE,
	PATROL,
	CHASE,
	SEEN_JUMP,
}

// TODO Maybe just a x direction (bool) and calculate speed based on state and then a y velocity for jumping. x direction doubles as is_flipped
Enemy :: struct {
	state: EnemyState,
	position: Vec2,
	cached_floor_height: f32,
	facing_right: bool,
	y_velocity: f32,
	time_to_next_state: f32,
	animator: Animator,
	surface_index: int,
}

EnemyList :: struct {
	enemies: [MAX_ENEMIES]Enemy,
	len: int,
}

draw_enemies :: proc(enemy_list: ^EnemyList, sequences: ^Sequences, platform: ^Platform, dt: f32) {
	for &enemy in enemy_list.enemies[:enemy_list.len] {
		using enemy

		animator.frame_length_mod = 1

		switch state {
		case EnemyState.PAUSE:
			animator.sequence = &sequences.guard_idle

		case EnemyState.PATROL:
			animator.sequence = &sequences.guard_run
			animator.flipped = !facing_right

		case EnemyState.CHASE:
			animator.sequence = &sequences.guard_run
			animator.frame_length_mod = 2
			animator.flipped = !facing_right

		case EnemyState.SEEN_JUMP:
			animator.sequence = &sequences.guard_jump

		}

		animator.sequence = &sequences.guard_idle
		if state != EnemyState.PAUSE {
			animator.sequence = &sequences.guard_run

			animator.frame_length_mod = 1
			if state == EnemyState.CHASE {
				animator.frame_length_mod = 0.66
			}
		}
		if state == EnemyState.SEEN_JUMP do animator.sequence = &sequences.guard_jump

		cycle_and_draw_animator(&animator, ivec2_from_vec2(position), platform, dt)
	}
}

init_enemies :: proc(enemy_list: ^EnemyList, data: ^LevelData, config: ^EnemyConfig) {
	enemy_list.len = 0
	for enemy_position in data.enemy_positions[:data.enemy_positions_len] {
		enemy_list.len += 1
		enemy := &enemy_list.enemies[enemy_list.len - 1]
		using enemy
		
		position = enemy_position
		state = EnemyState.PATROL
		cached_floor_height = position.y

		if rand.int_max(2) == 0 {
			facing_right = true
		}
		else {
			facing_right = false
		}
	}
}

update_enemy :: proc(enemy: ^Enemy, king: ^King, surface_map: ^SurfaceMap, config: ^EnemyConfig, sound_system: ^SoundSystem, dt: f32) {
	using enemy

	surface := &surface_map.surfaces[surface_index]
	#partial switch state {
	case EnemyState.PATROL:
		// TODO break this up into a check_surface_edge + inner loop as own function
		// This may be slightly more redundant, but may be worth it for readability
		// The code we write is a description of the problem being solved, but it is
		// also at its best a communication of the call flow with the maximum degree
		// of clarity.
		// Doing the most direct thing often leads to the clearest result, but doing
		// the most direct thing isn't the goal in of itself. Especially when there
		// is some ambiguity as to what the most direct thing is, clarity should be
		// brought to the front of mind.
		hit_edge := handle_surface_edge(enemy, surface, config)
		if hit_edge {
			break
		}

		if check_king_seen(enemy, king.position, surface_index, surface_map.king_surface) {
			state = EnemyState.SEEN_JUMP
			start_sound(&sound_system.channels[0], SoundType.ENEMY_ALARMED)
			y_velocity = -config.seen_jump_velocity
		}
		else {
			x_movement := config.patrol_speed
			if !facing_right do x_movement *= -1
			position.x += x_movement * dt
		}
	case EnemyState.PAUSE:
		time_to_next_state -= dt
		if time_to_next_state < 0 {
			state = EnemyState.PATROL
		}
	case EnemyState.SEEN_JUMP:
		y_velocity += config.seen_jump_gravity * dt
		position.y += y_velocity * dt
		if position.y > cached_floor_height {
			position.y = cached_floor_height
			state = EnemyState.CHASE
		}
	case EnemyState.CHASE:
		hit_edge := handle_surface_edge(enemy, surface, config)
		if hit_edge do break

		if !check_king_seen(enemy, king.position, surface_map.king_surface, surface_index) {
			// TODO maybe refactor into its own function from handle_surface_edge as well 
			state = EnemyState.PAUSE
			start_sound(&sound_system.channels[0], SoundType.ENEMY_LOST)
			time_to_next_state = config.lost_pause_length
		}
		else {
			x_movement := config.chase_speed
			if !facing_right do x_movement *= -1
			position.x += x_movement * dt
		}
	}
}

@(private="file")
handle_surface_edge :: proc(enemy: ^Enemy, surface: ^Surface, config: ^EnemyConfig) -> (hit_edge: bool) {
	using enemy

	if !facing_right && position.x < surface.left ||
	facing_right && position.x > surface.right {
		state = EnemyState.PAUSE
		facing_right = !facing_right
		time_to_next_state = config.edge_wait_length
		return true
	}
	return false
}

@(private="file")
check_king_seen :: proc(enemy: ^Enemy, king_position: Vec2, king_surface: int, enemy_surface: int) -> bool {
	using enemy

	return king_surface == enemy_surface && 
	facing_right == (king_position.x - position.x > 0)
}

check_king_caught :: proc(enemy_list: ^EnemyList, king: ^King) -> bool {
	for &enemy in enemy_list.enemies[:enemy_list.len] {
		king_collider := Rect{{-5, -16}, {10, 16}}
		enemy_collider := Rect{{-5, -16}, {10, 16}}
		if is_colliding(&king_collider, &king.position, &enemy_collider, &enemy.position) {
			return true
		}
	}
	return false
}
