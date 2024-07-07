package main

LEVEL_FNAME_PREFIX :: "levels/level"

// For serialization by level editor and loading from file to Level struct
LevelData :: struct {
	tiles: [NUM_TILES]u8,
	king_position: Vec2,
	window_positions: [MAX_WINDOWS]Vec2,
	window_positions_len: int,
	enemy_positions: [MAX_ENEMIES]Vec2,
	enemy_positions_len: int,
}
