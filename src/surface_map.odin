package main
import "core:fmt"

MAX_SURFACES :: 128

Surface :: struct {
	left: f32,
	right: f32,
}

SurfaceMap :: struct {
	surfaces: [MAX_SURFACES]Surface,
	surfaces_len: int,
	king_surface: int,
}

interpret_surfaces :: proc(tilemap: ^Tilemap, surface_map: ^SurfaceMap, enemy_list: ^EnemyList, king_position: Vec2) {
	using surface_map

	surfaces_len = 0
	surface_in_progress := false
	king_surface = -1

	for &tile, index in tilemap {
		buffered_health := get_buffered_health(&tile)
		tile_position := tile_position_from_index(index)

		if !surface_in_progress {
			if buffered_health > 0 {
				surface_in_progress = true
				surfaces[surfaces_len].left = tile_position.x
				surfaces_len += 1
			}
		}
		else {
			if buffered_health <= 0 {
				surface_in_progress = false
				surfaces[surfaces_len - 1].right = tile_position_from_index(index - 1).x
			}
		}

		if buffered_health > 0 {
			if check_entity_on_tile(tile_position, king_position) {
				king_surface = surfaces_len - 1
			}

			for &enemy in enemy_list.enemies[:enemy_list.len] {
				if check_entity_on_tile(tile_position, enemy.position) {
					enemy.surface_index = surfaces_len - 1
				}
			}
		}
	}
}

check_entity_on_tile :: proc(tile_position: Vec2, entity_position: Vec2) -> bool {
	return abs(entity_position.y - tile_position.y) < 1 && abs(entity_position.x - tile_position.x) < 17
}
