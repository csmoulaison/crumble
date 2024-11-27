package main

Config :: struct {
	starting_lives: int,
	pre_active_length: f32,
	post_loss_length: f32,
	post_win_length: f32,
	level_interstitial_length: f32,

	king_max_speed: f32,
	king_base_acceleration: f32,
	king_base_gravity: f32,
	king_jump_velocity: f32,
	king_float_velocity: f32,
	king_acceleration_scale_per_food: f32,
	king_fall_gravity_scale: f32,
	king_jump_gravity_length: f32,
	king_jump_gravity_scale: f32,
	king_jump_gravity_scale_down: f32,
	king_float_initial_gravity_scale: f32,
	king_float_target_gravity_scale: f32,
	king_float_gravity_lerp_speed: f32,
	king_pot_bounce_speed: f32,

	food_inactive_length: f32,
	food_cook_length: f32,
	food_expiration_length: f32,
	food_blink_length: f32,
	food_distance_to_eat: f32,
	food_pot_expiration_length: f32,
	food_reset_length: f32,
	food_hitch_length: f32,
	food_high_points: int,
	food_low_points: int,
	food_end_points: int,

	enemy_patrol_speed: f32,
	enemy_chase_speed: f32,
	enemy_edge_wait_length: f32,
	enemy_seen_jump_velocity: f32,
	enemy_seen_jump_gravity: f32,
	enemy_lost_pause_length: f32,

	tile_crumble_length: f32,

	scoreboard_editing_blink_length: f32,
}

init_config :: proc(config: ^Config) {
	using config

	starting_lives = 3
	pre_active_length = 2
	post_loss_length = 2
	post_win_length = 2
	level_interstitial_length = 5

	king_max_speed = 140
	king_base_acceleration = 600
	king_base_gravity = 900
	king_jump_velocity = 270
	king_float_velocity = 170
	king_acceleration_scale_per_food = 0.85
	king_fall_gravity_scale = 1.0
	king_jump_gravity_length = 0.5
	king_jump_gravity_scale = 0.6
	king_jump_gravity_scale_down = 0.9
	king_float_initial_gravity_scale = 0.4
	king_float_target_gravity_scale = 0.1
	king_float_gravity_lerp_speed = 2
	king_pot_bounce_speed = 300

	enemy_patrol_speed = 50
	enemy_chase_speed = 100
	enemy_edge_wait_length = 1.25
	enemy_seen_jump_velocity = 250
	enemy_seen_jump_gravity = 2000
	enemy_lost_pause_length = 0.6

	food_distance_to_eat = 16
	food_inactive_length = 4
	food_cook_length = 4
	food_expiration_length = 8
	food_blink_length = 0.25
	food_pot_expiration_length = 10
	food_reset_length = 2
	food_hitch_length = 0.25
	food_high_points = 20
	food_low_points = 10
	food_end_points = 200

	tile_crumble_length = 0.5

	scoreboard_editing_blink_length = 0.5
}
