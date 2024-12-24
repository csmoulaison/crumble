package main
import SDL "vendor:sdl2"
import MA "vendor:miniaudio"
import "core:fmt"
import "core:strings"
import "core:math"

// Imaginary pixel art width
LOGICAL_WIDTH :: 640
// Imaginary pixel resolution height
LOGICAL_HEIGHT :: 480
// Maximum keyboard inputs stored each frame
MAX_SCANCODE_INPUTS :: 128 
// Maximum sprites allowed to be onscreen at once
MAX_ONSCREEN_SPRITES :: 512
// Maximum text displays allowed onscreen at once
MAX_TEXTS :: 64
// Maximum number of textures used throghout game
MAX_TEXTURES :: 16

Platform :: struct {
	// SDL resources
	window: ^SDL.Window, //
	renderer: ^SDL.Renderer, //
	screen_width: i32, //
	screen_height: i32, //
	// Miniaudio resources
	// TODO probably don't need configs hardcoded. Maybe, IDK
	audio: Audio,
	// Input state
	keydowns: [MAX_SCANCODE_INPUTS]SDL.Scancode,
	keyups: [MAX_SCANCODE_INPUTS]SDL.Scancode,
	keydowns_len: int,
	keyups_len: int,
	ready_to_quit: bool, //
	// Output state
	background_color: Color, // 
	sprites: [MAX_ONSCREEN_SPRITES]Sprite,
	sprites_len: int,
	logical_offset: IVec2,
	logical_offset_active: bool,
	// Assets
	sprite_atlas_handle: int,
	textures: [MAX_TEXTURES]^SDL.Texture, //
	textures_len: int,
	window_icon: ^SDL.Surface,
	// Misc
	clock: f32,
	mod_glitchy: bool,
	glitch_chance: f32,
}

init_platform :: proc(platform: ^Platform) {
	using platform

	SDL.Init(SDL.INIT_EVERYTHING)
	display_mode: SDL.DisplayMode
	SDL.GetDesktopDisplayMode(0, &display_mode)
	screen_width = display_mode.w
	screen_height = display_mode.h

	window = SDL.CreateWindow("Crumble King", 0, 0, screen_width, screen_height, SDL.WINDOW_BORDERLESS)
	//window = SDL.CreateWindow("Crumble King", 0, 0, 0, 0, SDL.WINDOW_RESIZABLE)
	renderer = SDL.CreateRenderer(window, -1, SDL.RENDERER_ACCELERATED)

	sprite_atlas_handle = new_texture_handle(platform, "textures/sprite_atlas.bmp")
	window_icon = load_surface("textures/icon_original.bmp")
	SDL.SetWindowIcon(window, window_icon)

	init_audio(&audio)

	for i: i32 = 0; i < SDL.NumJoysticks(); i += 1 {
		if (SDL.IsGameController(i)) {
			SDL.GameControllerOpen(i);
		}
	    }
}

update_platform :: proc(platform: ^Platform) {
	using platform

	SDL.ShowCursor(0)

	//Prepare screen
	SDL.SetRenderDrawColor(
		renderer,
		background_color.r,
		background_color.g,
		background_color.b,
		SDL.ALPHA_OPAQUE);
	SDL.RenderClear(renderer)

	// Draw sprites
	//pixel_scalar: int = int(screen_height / LOGICAL_HEIGHT)
	//pixel_scalar: int = 3
	//offset := IVec2{(int(screen_width) - LOGICAL_WIDTH * pixel_scalar) / 2, int((screen_height % LOGICAL_HEIGHT) / 2)}
	//offset := IVec2{(int(screen_width) - LOGICAL_WIDTH * pixel_scalar) / 2 - 32, 64}

	pixel_scalar: int = int(screen_height / LOGICAL_HEIGHT)
	SDL.SetRenderDrawColor(renderer, 255, 0, 255, 255)
	//SDL.RenderDrawLine(renderer, 0, screen_height / 2, screen_width, screen_height / 2)

	screen_canvas_width: int = LOGICAL_WIDTH * pixel_scalar			
	pillarbox: int = (int(screen_width) - screen_canvas_width) / 2
	offset := IVec2{pillarbox, 0}

	SDL.SetRenderDrawColor(renderer, 255, 255, 255, 255)
	//SDL.RenderDrawLine(renderer, i32(pillarbox), 0, i32(pillarbox), screen_height)

	// Screen space center line
	SDL.SetRenderDrawColor(renderer, 255, 0, 255, 255)
	//SDL.RenderDrawLine(renderer, screen_width / 2, 0, screen_width / 2, screen_height)

	// Logical space center line
	SDL.SetRenderDrawColor(renderer, 0, 255, 0, 255)
	x: i32 = i32((LOGICAL_WIDTH / 2) + offset.x) * i32(pixel_scalar)
	//SDL.RenderDrawLine(renderer, x, 0, x, screen_height)

	for &sprite in sprites[:sprites_len] {
		using sprite

		src: SDL.Rect 
		src.x = i32(texture_src.position.x)
		src.y = i32(texture_src.position.y)
		src.w = i32(texture_src.size.x)
		src.h = i32(texture_src.size.y)

		dst: SDL.Rect
		dst.x = i32(((position.x - origin.x) * pixel_scalar) + offset.x)
		dst.y = i32(((position.y - origin.y) * pixel_scalar) + offset.y)
		dst.w = i32(texture_src.size.x * pixel_scalar)
		dst.h = i32(texture_src.size.y * pixel_scalar)

		flip: SDL.RendererFlip = SDL.RendererFlip.NONE
		if is_flipped {
			flip = SDL.RendererFlip.HORIZONTAL
		}

		SDL.RenderCopyEx(
			renderer,
			textures[atlas],
			&src,
			&dst,
			0,
			nil,
			flip);
	}
	sprites_len = 0

	// Scanlines
	if true {
		scanline_color_map: [8]i8 = {-128, -128, -128, -128, -128, -128, 0, 0}
		if pixel_scalar == 1 {
			scanline_color_map[0] = 0
		} else if pixel_scalar == 2 {
			scanline_color_map[0] = -64
			scanline_color_map[1] = 1
		} else if pixel_scalar == 3 {
			scanline_color_map[0] = -64
			scanline_color_map[1] = 2
			scanline_color_map[2] = -96
		} else if pixel_scalar == 4 {
			scanline_color_map[0] = -128
			scanline_color_map[1] = -64
			scanline_color_map[2] = 2
			scanline_color_map[3] = -64
		} else if pixel_scalar > 4 {
			scanline_color_map[0] = -128
			scanline_color_map[1] = -64
			scanline_color_map[2] = 2
			scanline_color_map[3] = 1
			scanline_color_map[4] = -64
		}
		for i: int = 0; i * pixel_scalar < int(screen_height); i += 1 {
			for j: int = 0; j < pixel_scalar; j += 1 {
				scanline_y: i32 = i32(pixel_scalar + i * pixel_scalar + j)

				if scanline_color_map[j] <= 0 {
					SDL.SetRenderDrawBlendMode(renderer, SDL.BlendMode.BLEND)
					SDL.SetRenderDrawColor(renderer, 0, 0, 0, transmute(u8)math.abs(scanline_color_map[j]))
				} else {
					SDL.SetRenderDrawBlendMode(renderer, SDL.BlendMode.MUL)
					SDL.SetRenderDrawColor(renderer, 255, 255, 255, transmute(u8)math.abs(scanline_color_map[j]))
				}
				SDL.RenderDrawLine(renderer, 0, scanline_y, screen_width, scanline_y)
			}
		}
	}

	SDL.RenderPresent(renderer)
	
	// Poll input events
	keydowns_len = 0
	keyups_len = 0

	event: SDL.Event
	for SDL.PollEvent(&event) {
		#partial switch event.type {
		case SDL.EventType.QUIT:
			ready_to_quit = true
		case SDL.EventType.KEYDOWN:
			keydowns[keydowns_len] = event.key.keysym.scancode
			keydowns_len += 1
		case SDL.EventType.KEYUP:
			keyups[keyups_len] = event.key.keysym.scancode
			keyups_len += 1
		case SDL.EventType.CONTROLLERBUTTONDOWN:
			switch event.cbutton.button {
			case u8(SDL.GameControllerButton.A):
				keydowns[keydowns_len] = SDL.Scancode.SPACE
				keydowns_len += 1
			case u8(SDL.GameControllerButton.START):
				keydowns[keydowns_len] = SDL.Scancode.SPACE
				keydowns_len += 1
			case u8(SDL.GameControllerButton.DPAD_LEFT):
				keydowns[keydowns_len] = SDL.Scancode.LEFT
				keydowns_len += 1
			case u8(SDL.GameControllerButton.DPAD_RIGHT):
				keydowns[keydowns_len] = SDL.Scancode.RIGHT
				keydowns_len += 1
			case u8(SDL.GameControllerButton.DPAD_UP):
				keydowns[keydowns_len] = SDL.Scancode.UP
				keydowns_len += 1
			case u8(SDL.GameControllerButton.DPAD_DOWN):
				keydowns[keydowns_len] = SDL.Scancode.DOWN
				keydowns_len += 1
			case u8(SDL.GameControllerButton.B):
				keydowns[keydowns_len] = SDL.Scancode.ESCAPE
				keydowns_len += 1
			}
		case SDL.EventType.CONTROLLERBUTTONUP:
			switch event.cbutton.button {
			case u8(SDL.GameControllerButton.A):
				keyups[keyups_len] = SDL.Scancode.SPACE
				keyups_len += 1
			case u8(SDL.GameControllerButton.START):
				keyups[keyups_len] = SDL.Scancode.SPACE
				keyups_len += 1
			case u8(SDL.GameControllerButton.DPAD_LEFT):
				keyups[keyups_len] = SDL.Scancode.LEFT
				keyups_len += 1
			case u8(SDL.GameControllerButton.DPAD_RIGHT):
				keyups[keyups_len] = SDL.Scancode.RIGHT
				keyups_len += 1
			case u8(SDL.GameControllerButton.DPAD_UP):
				keyups[keyups_len] = SDL.Scancode.UP
				keyups_len += 1
			case u8(SDL.GameControllerButton.DPAD_DOWN):
				keyups[keyups_len] = SDL.Scancode.DOWN
				keyups_len += 1
			case u8(SDL.GameControllerButton.B):
				keyups[keyups_len] = SDL.Scancode.ESCAPE
				keyups_len += 1
			}
		case SDL.EventType.WINDOWEVENT:
			if event.window.event == SDL.WindowEventID.RESIZED {
				screen_width = event.window.data1
				screen_height = event.window.data2
			}
		}
	}
}

cleanup_platform :: proc(platform: ^Platform) {
	SDL.DestroyWindow(platform.window)
}

// Loads a bitmap file and keys out pure magenta background, returning an SDL surface
load_surface :: proc(fname: cstring) -> ^SDL.Surface {
	surface: ^SDL.Surface = SDL.LoadBMP(fname)
	if surface == nil {
		fmt.print("Error loading surface '")
		fmt.print(fname)
		fmt.print("'. Returned nil.")
		fmt.println()
	}

	background_color_key := SDL.MapRGB(surface.format, 255, 0, 255)
	SDL.SetColorKey(surface, 1, background_color_key)

	return surface
}

new_texture_handle :: proc(platform: ^Platform, fname: cstring) -> int {
	surface: ^SDL.Surface = load_surface(fname)
	platform.textures[platform.textures_len] = SDL.CreateTextureFromSurface(platform.renderer, surface)
	platform.textures_len += 1
	return platform.textures_len - 1
}
