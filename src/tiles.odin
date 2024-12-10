package main
import "core:fmt"
import "core:math/rand"

NUM_TILES :: 900
TILE_ROW_WIDTH :: 30
TILE_PIXEL_SIZE :: 16
MAX_TILE_HEALTH :: 3

Tilemap :: [NUM_TILES]Tile

Tile :: struct {
	health: u8,
	is_crumbling: bool,
	time_till_crumble: f32,
	orientation: TileOrientation,
}

TileOrientation :: enum {
	LEFT,
	CENTER,
	RIGHT,
	ISLAND,
}

init_tilemap :: proc(tilemap: ^Tilemap, config: ^Config, data: ^LevelData) {
	for tile, i in data.tiles {
		if tile != 0 do tilemap[i].health = MAX_TILE_HEALTH
		else do tilemap[i].health = 0

		tilemap[i].time_till_crumble = 0
	}
}

draw_tilemap :: proc(tilemap: ^Tilemap, sequences: ^Sequences, current_level: int, platform: ^Platform) {
	level_tile_position: IVec2 = {480, 32}
	level_tile_position.y += current_level * 16

	for &tile, index in tilemap {
		if tile.health == 0 do continue

		// Setup tile orientation
		health: u8 = get_buffered_health(&tile)
		left_health: u8 = 0
		if index > 0 do left_health = get_buffered_health(&tilemap[index - 1])
		right_health: u8 = 0
		if index < NUM_TILES + 1 do right_health = get_buffered_health(&tilemap[index + 1])

		tile.orientation = TileOrientation.ISLAND
		if left_health >= health {
			tile.orientation = TileOrientation.RIGHT
			if right_health >= health {
				tile.orientation = TileOrientation.CENTER
			}
		}
		else if right_health >= health {
			tile.orientation = TileOrientation.LEFT
		}

		position := tile_screen_position_from_index(index)
		buffered_health := get_buffered_health(&tile)

		src := sequences.tile_island_src
		if tile.orientation == TileOrientation.CENTER do src = sequences.tile_center_src
		else if tile.orientation == TileOrientation.LEFT do src = sequences.tile_left_src
		else if tile.orientation == TileOrientation.RIGHT do src = sequences.tile_right_src

		src.position.x += int(buffered_health) * TILE_PIXEL_SIZE
		src.position += level_tile_position

		buffer_sprite(platform, src, position, IVec2{8,0}, false)
	}
}

update_tile_crumble :: proc(tilemap: ^Tilemap, config: ^Config, dt: f32) {
	for &tile in tilemap {
		using tile
		
		if is_crumbling {
			time_till_crumble -= dt
			if time_till_crumble < 0 {
				health -= 1
				is_crumbling = false
				time_till_crumble = config.tile_degrade_length // only matters in the builder case
			}
		}
	}
}

update_tile_degrade :: proc(tilemap: ^Tilemap, config: ^Config, dt: f32) {
	for &tile in tilemap {
		using tile
		
		if health > 0 && !is_crumbling {
			time_till_crumble -= dt
			if time_till_crumble < 0 {
				is_crumbling = true
				tile.time_till_crumble = config.tile_crumble_length
			}
		}
	}
}

tile_position_from_index :: proc(index: int) -> Vec2 {
	y: int = index / TILE_ROW_WIDTH
	x: int = index - y * TILE_ROW_WIDTH
	return Vec2{f32(x * TILE_PIXEL_SIZE), f32(y * TILE_PIXEL_SIZE)}
}

tile_screen_position_from_index :: proc(index: int) -> IVec2 {
	y: int = index / TILE_ROW_WIDTH
	x: int = index - y * TILE_ROW_WIDTH
	return IVec2{x * TILE_PIXEL_SIZE, y * TILE_PIXEL_SIZE}
}

index_from_tile_screen_position :: proc(position: IVec2) -> int {
	coords: IVec2 = position
	coords.x /= TILE_PIXEL_SIZE
	coords.y /= TILE_PIXEL_SIZE

	return coords.y * TILE_ROW_WIDTH + coords.x
}

get_buffered_health :: proc(tile: ^Tile) -> u8 {
	if tile.is_crumbling do return tile.health - 1
	return tile.health
}
