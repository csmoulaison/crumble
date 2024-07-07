package main

Config :: struct {
	level: LevelConfig,
	king: KingConfig,
	food: FoodConfig,
	enemy: EnemyConfig,
	tile: TileConfig,
	leaderboard: LeaderboardConfig,
}

LevelConfig :: struct {
	starting_lives: int,
	pre_active_length: f32,
	post_loss_length: f32,
	post_win_length: f32,
	level_interstitial_length: f32,
	tower_interstitial_length: f32,
}

KingConfig :: struct {
	max_speed: f32,
	initial_acceleration: f32,
	base_gravity: f32,
	jump_velocity: f32,
	float_velocity: f32,
	acceleration_scale_per_food: f32,
	fall_gravity_scale: f32,
	jump_gravity_length: f32,
	jump_gravity_scale: f32,
	jump_gravity_scale_down: f32,
	float_initial_gravity_scale: f32,
	float_target_gravity_scale: f32,
	float_gravity_lerp_speed: f32,
	pot_bounce_speed: f32,
}

FoodConfig :: struct {
	inactive_length: f32,
	cook_length: f32,
	expiration_length: f32,
	blink_length: f32,
	distance_to_eat: f32,
	pot_expiration_length: f32,
	reset_length: f32,
	hitch_length: f32,
	high_points: int,
	low_points: int,
	end_points: int,
}

EnemyConfig :: struct {
	patrol_speed: f32,
	chase_speed: f32,
	edge_wait_length: f32,
	seen_jump_velocity: f32,
	seen_jump_gravity: f32,
	lost_pause_length: f32,
}

TileConfig :: struct {
	crumble_tile_length: f32,
}

LeaderboardConfig :: struct {
	editing_blink_length: f32,
}

init_config :: proc(config: ^Config) {
	using config

	level.starting_lives = 3
	level.pre_active_length = 2
	level.post_loss_length = 2
	level.post_win_length = 2
	level.level_interstitial_length = 5
	level.tower_interstitial_length = 9

	king.max_speed = 140
	king.initial_acceleration = 600
	king.base_gravity = 900
	king.jump_velocity = 270
	king.float_velocity = 170
	king.acceleration_scale_per_food = 0.85
	king.fall_gravity_scale = 1.0
	king.jump_gravity_length = 0.5
	king.jump_gravity_scale = 0.6
	king.jump_gravity_scale_down = 0.9
	king.float_initial_gravity_scale = 0.4
	king.float_target_gravity_scale = 0.1
	king.float_gravity_lerp_speed = 2
	king.pot_bounce_speed = 300

	/* OVERWRITE FOR ALTERNATE KING
	king.float_velocity = 100
	king.float_initial_gravity_scale = -0.1
	king.float_target_gravity_scale = 0.9
	king.float_gravity_lerp_speed = 0.3
	*/

	enemy.patrol_speed = 50
	enemy.chase_speed = 100
	enemy.edge_wait_length = 1.25
	enemy.seen_jump_velocity = 250
	enemy.seen_jump_gravity = 2000
	enemy.lost_pause_length = 0.6

	food.distance_to_eat = 16
	food.inactive_length = 4
	food.cook_length = 4
	food.expiration_length = 8
	food.blink_length = 0.25
	food.pot_expiration_length = 10
	food.reset_length = 2
	food.hitch_length = 0.25
	food.high_points = 20
	food.low_points = 10
	food.end_points = 200

	tile.crumble_tile_length = 0.5

	leaderboard.editing_blink_length = 0.5
}
