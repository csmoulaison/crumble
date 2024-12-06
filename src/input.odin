package main
import "vendor:sdl2"
import "core:fmt"

MAX_SCANCODE_BUTTON_MAPPINGS :: 32
MAX_BUTTONS :: 32

Button :: struct {
	held: bool,
	just_pressed: bool,
	just_released: bool,
	// do we need the below?
	// modified: bool,
}

ScancodeButtonMapping :: struct {
	scancode: sdl2.Scancode,
	button: ^Button,
}

Input :: struct {
	any_just_pressed: bool,
	scancode_button_map: [MAX_SCANCODE_BUTTON_MAPPINGS]ScancodeButtonMapping,
	scancode_button_map_len: int,
	mapped_buttons: [MAX_BUTTONS]^Button,
	mapped_buttons_len: int,
	// Gameplay buttons
	left: Button, 
	right: Button,
	jump: Button,
	// Menu buttons
	up: Button,
	down: Button,
	select: Button,
	// Editor buttons
	cycle_forward: Button,
	cycle_back: Button,
	place: Button,
	cursor_up: Button,
	cursor_down: Button,
	cursor_left: Button,
	cursor_right: Button,
	editor_quicksave: Button,
	editor_quickload: Button,
	editor_incr_lvl: Button,
	editor_decr_lvl: Button,
	// Tower editor buttons
	add_tower_level: Button,
	remove_tower_level: Button,
	// Misc buttons
	quit: Button,
}

init_input :: proc(input: ^Input) {
	// Map gameplay buttons
	map_scancode_to_button(sdl2.SCANCODE_A, &input.left, input)
	map_scancode_to_button(sdl2.SCANCODE_LEFT, &input.left, input)

	map_scancode_to_button(sdl2.SCANCODE_D, &input.right, input)
	map_scancode_to_button(sdl2.SCANCODE_RIGHT, &input.right, input)

	map_scancode_to_button(sdl2.SCANCODE_W, &input.jump, input)
	map_scancode_to_button(sdl2.SCANCODE_UP, &input.jump, input)
	map_scancode_to_button(sdl2.SCANCODE_SPACE, &input.jump, input)

	// Map menu buttons
	map_scancode_to_button(sdl2.SCANCODE_UP, &input.up, input)
	map_scancode_to_button(sdl2.SCANCODE_W, &input.up, input)

	map_scancode_to_button(sdl2.SCANCODE_DOWN, &input.down, input)
	map_scancode_to_button(sdl2.SCANCODE_S, &input.down, input)

	map_scancode_to_button(sdl2.SCANCODE_SPACE, &input.select, input)
	map_scancode_to_button(sdl2.SCANCODE_RETURN, &input.select, input)

	// Map editor buttons
	map_scancode_to_button(sdl2.SCANCODE_TAB, &input.cycle_forward, input)
	map_scancode_to_button(sdl2.SCANCODE_RIGHT, &input.cycle_forward, input)
	map_scancode_to_button(sdl2.SCANCODE_E, &input.cycle_forward, input)

	map_scancode_to_button(sdl2.SCANCODE_LEFT, &input.cycle_back, input)
	map_scancode_to_button(sdl2.SCANCODE_Q, &input.cycle_back, input)

	map_scancode_to_button(sdl2.SCANCODE_RETURN, &input.place, input)
	map_scancode_to_button(sdl2.SCANCODE_SPACE, &input.place, input)

	// Tower editor button
	map_scancode_to_button(sdl2.SCANCODE_EQUALS, &input.add_tower_level, input)
	map_scancode_to_button(sdl2.SCANCODE_MINUS, &input.remove_tower_level, input)

	map_scancode_to_button(sdl2.SCANCODE_W, &input.cursor_up, input)
	map_scancode_to_button(sdl2.SCANCODE_A, &input.cursor_left, input)
	map_scancode_to_button(sdl2.SCANCODE_S, &input.cursor_down, input)
	map_scancode_to_button(sdl2.SCANCODE_D, &input.cursor_right, input)

	map_scancode_to_button(sdl2.SCANCODE_F5, &input.editor_quicksave, input)
	map_scancode_to_button(sdl2.SCANCODE_F9, &input.editor_quickload, input)

	map_scancode_to_button(sdl2.SCANCODE_EQUALS, &input.editor_incr_lvl, input)
	map_scancode_to_button(sdl2.SCANCODE_MINUS, &input.editor_decr_lvl, input)

	// Map misc buttons
	map_scancode_to_button(sdl2.SCANCODE_ESCAPE, &input.quit, input)
}

map_scancode_to_button :: proc(scancode: sdl2.Scancode, button: ^Button, input: ^Input) {
	using input

	scancode_button_map[scancode_button_map_len] = ScancodeButtonMapping{scancode, button}
	scancode_button_map_len += 1

	matched_button: bool
	for &mapped_button in mapped_buttons[:mapped_buttons_len] {
		if button == mapped_button {
			matched_button = true
		}
	}
	if !matched_button {
		mapped_buttons[mapped_buttons_len] = button
		mapped_buttons_len += 1
	}
}

update_input :: proc(input: ^Input, platform: ^Platform) {
	using input
	using platform

	for &button in mapped_buttons[:mapped_buttons_len] {
		button.just_pressed = false
		button.just_released = false
	}

	for &keydown in keydowns[:keydowns_len] {
		for mapping in scancode_button_map[:scancode_button_map_len] {
			if keydown == mapping.scancode && !mapping.button.held {
				mapping.button.held = true
				mapping.button.just_pressed = true
				any_just_pressed = true
			}
		}
	}

	for &keyup in keyups[:keyups_len] {
		for mapping in scancode_button_map[:scancode_button_map_len] {
			if keyup == mapping.scancode {
				if mapping.button.held do mapping.button.just_released = true
				mapping.button.held = false
			}
		}
	}
}
