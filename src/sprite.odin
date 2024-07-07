package main
import "core:fmt"

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
	platform.sprites[platform.sprites_len] = sprite
	platform.sprites_len += 1
}
