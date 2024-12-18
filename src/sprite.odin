package main
import "core:fmt"
import "core:math/rand"

Sprite :: struct {
	texture_src: IRect,
	position: IVec2,
	origin: IVec2,
	is_flipped: bool,
	atlas: int,
}

buffer_sprite :: proc{buffer_sprite_raw, buffer_sprite_default_atlas, buffer_sprite_chosen_atlas}

@(private="file")
buffer_sprite_default_atlas :: proc(platform: ^Platform, texture_src: IRect, position: IVec2, origin: IVec2, is_flipped: bool) {
	buffer_sprite(
		platform,
		Sprite {
			texture_src,
			position,
			origin,
			is_flipped,
			platform.sprite_atlas_handle})
}

@(private="file")
buffer_sprite_chosen_atlas :: proc(platform: ^Platform, texture_src: IRect, position: IVec2, origin: IVec2, is_flipped: bool, atlas: int) {
	buffer_sprite(
		platform,
		Sprite {
			texture_src,
			position,
			origin,
			is_flipped,
			atlas})
}

@(private="file")
buffer_sprite_raw :: proc(platform: ^Platform, sprite: Sprite) {
	spr: Sprite = sprite
	if platform.logical_offset_active {
		spr.position.x += platform.logical_offset.x
		spr.position.y += platform.logical_offset.y
	}

	if platform.mod_glitchy {
		chance: int = int(platform.glitch_chance * 1000)
		if chance < 1 {
			chance = 1
		}
		if rand.int_max(chance) < 1000 {
			spr.texture_src.position.x = rand.int_max(26) * 16
			spr.texture_src.position.y = rand.int_max(16) * 16
		}

		x_off: int = 0
		y_off: int = 0
		if rand.int_max(chance) < 1000 {
			x_off += rand.int_max(3) - 1
			x_off += rand.int_max(3) - 1
			if rand.int_max(chance) < 1000 {
				x_off += rand.int_max(5) - 2
				x_off += rand.int_max(5) - 2
				if rand.int_max(chance) < 1000 {
					x_off += rand.int_max(7) - 3
					x_off += rand.int_max(6) - 3
				}
			}
		}
		spr.position.x += x_off
		spr.position.y += y_off
	}
	
	platform.sprites[platform.sprites_len] = spr
	platform.sprites_len += 1
}
