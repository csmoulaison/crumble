package main
import SDL "vendor:sdl2"
import MA "vendor:miniaudio"
import "core:fmt"
import "core:strings"
import "core:math"

// Imaginary pixel art width
LOGICAL_WIDTH :: 480 
// Imaginary pixel resolution height
LOGICAL_HEIGHT :: 360 
// Maximum keyboard inputs stored each frame
MAX_SCANCODE_INPUTS :: 128 
// Maximum sprites allowed to be onscreen at once
MAX_ONSCREEN_SPRITES :: 512
// Maximum text displays allowed onscreen at once
MAX_TEXTS :: 64
// Maximum number of fonts used throughout game
MAX_FONTS :: 4
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
	texts: [MAX_TEXTS]Text,
	texts_len: int,
	// Assets
	sprite_atlas_handle: int,
	textures: [MAX_TEXTURES]^SDL.Texture, //
	textures_len: int,
	fonts: [MAX_FONTS]Font,
	fonts_len: int,
	window_icon: ^SDL.Surface,
	// Misc
	time_passed: f32,
}

init_platform :: proc(platform: ^Platform) {
	using platform

	SDL.Init(SDL.INIT_EVERYTHING)
	display_mode: SDL.DisplayMode
	SDL.GetDesktopDisplayMode(0, &display_mode)
	screen_width = display_mode.w
	screen_height = display_mode.h

	window = SDL.CreateWindow("Crumble King", 0, 0, screen_width, screen_height, SDL.WINDOW_BORDERLESS)
	renderer = SDL.CreateRenderer(window, -1, SDL.RENDERER_ACCELERATED)

	sprite_atlas_handle = new_texture_handle(platform, "textures/sprite_atlas.bmp")
	window_icon = load_surface("textures/icon_original.bmp")
	SDL.SetWindowIcon(window, window_icon)

	init_audio(&audio)
}

update_platform :: proc(platform: ^Platform) {
	using platform

	// Buffer text sprites
	for &text in texts[:texts_len] {
		pos_x: int = text.position.x
		for c, i in text.string {
			font: ^Font = &fonts[text.font_index]

			off_y: f32 = math.sin((text.wave_t - f32(i))) * text.wave_amplitude - text.wave_amplitude / 2

			buffer_sprite(
				platform,
				IRect{{font.chars[c].pos, 3}, {font.chars[c].width, 20}},
				IVec2{pos_x, text.position.y - int(off_y)},
				IVec2{0,0},
				false,
				font.atlas_handle)

			pos_x += font.chars[c].width + 1
		}
	}
	texts_len = 0

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
	pixel_scalar: int = 3
	//offset := IVec2{(int(screen_width) - LOGICAL_WIDTH * pixel_scalar) / 2, int((screen_height % LOGICAL_HEIGHT) / 2)}
	offset := IVec2{(int(screen_width) - LOGICAL_WIDTH * pixel_scalar) / 2 - 32, 64}
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

	SDL.SetRenderDrawColor(
		renderer,
		0,
		0,
		0,
		8);
	for i: int = 0; i * pixel_scalar < int(screen_height); i += 1 {
		//scanline_y: i32 = i32(pixel_scalar - 1 + i * pixel_scalar)
		//SDL.RenderDrawLine(renderer, 0, scanline_y, screen_width, scanline_y)
	}

	SDL.RenderPresent(renderer)


	// Play audio
	
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

new_font_handle :: proc(platform: ^Platform, fname: cstring) -> int {
	font: Font

	font.atlas_handle = new_texture_handle(platform, fname)
	font.chars = get_charset()
	font.height = 26

	platform.fonts[platform.fonts_len] = font
	platform.fonts_len += 1
	return platform.fonts_len - 1
}
