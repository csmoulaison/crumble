package main
import "core:os"
import "core:strings"
import "core:strconv"

// TODO
// - Convert old music src to styles format
// - Load shit
// - Convert mini music tracks and preload at start
// - Deprecate push_note functionality and inline (?) direct values here
// - Load full music tracks at level load
// - Make music editor. Type styles manually, loaded and used at runtime

MUSIC_FNAME_PREFIX :: "music/music"
MAX_MUSIC_STYLES :: 16

MusicLoadState :: enum {
	SETTINGS,
	STYLES,
	MELODY,
	HARMONY
};

MusicLoadContext :: struct {
	state: MusicLoadState,
	styles: [MAX_MUSIC_STYLES]NoteSettings,
	styles_len: int,
};

deserialize_music :: proc(result: ^MusicData, index: int) -> (ok: bool) {
    data, read_ok := os.read_entire_file(get_music_fname(index))
    if !read_ok {
       return false
    }

    loader: MusicLoadContext
    music: MusicData

	text := string(data)
	for line in strings.split_lines_iterator(&text) {
		is_header_line: bool = true

		if line == "settings" {
			loader.state = MusicLoadState.SETTINGS
		} else if line == "styles" {
			loader.state = MusicLoadState.STYLES
		} else if line == "melody" {
			loader.state = MusicLoadState.MELODY
		} else if line == "harmony" {
			loader.state = MusicLoadState.HARMONY
		} else {
			is_header_line = false
		}

		if is_header_line {
			continue
		}

		switch loader.state {
		case MusicLoadState.SETTINGS:
			music.tempo = f32(strconv.atoi(line))
		case MusicLoadState.STYLES:
		case MusicLoadState.MELODY:
		case MusicLoadState.HARMONY:
		}
	}
    
    return true
}

@(private="file")
get_music_fname :: proc(index: int) -> string {
	fname := strings.builder_make()
	strings.write_string(&fname, MUSIC_FNAME_PREFIX)
	strings.write_int(&fname, index)
	strings.write_string(&fname, ".mus")
	return strings.to_string(fname)
}
