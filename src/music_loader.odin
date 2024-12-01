package main
import "core:fmt"
import "core:os"
import "core:math"
import "core:strings"
import "core:strconv"

// TODO:
// - Convert old music src to styles in file format
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


deserialize_music :: proc(result: ^MusicData, fname: string) {
	fmt.println("Loading music...", fname)
    data, read_ok := os.read_entire_file(fname)
    if !read_ok {
	    fmt.println("Read not ok!")
	    os.exit(1)
    }

    loader: MusicLoadContext

	result.tracks[0] = init_track()
	result.tracks[1] = init_track()
	result.tracks[2] = init_track()

	text := string(data)
	for line in strings.split_lines_iterator(&text) {
		if line == "settings" {
			loader.state = MusicLoadState.SETTINGS
			continue
		} else if line == "styles" {
			loader.state = MusicLoadState.STYLES
			continue
		} else if line == "melody" {
			loader.state = MusicLoadState.MELODY
			continue
		} else if line == "harmony" {
			loader.state = MusicLoadState.HARMONY
			continue
		}

		switch loader.state {
		case MusicLoadState.SETTINGS:
			result.tempo = f32(strconv.atoi(line))
		case MusicLoadState.STYLES:
			style: NoteSettings
			style.amplitude = read_float(line, 0, 3)
			style.octave_offset = read_float(line, 4, 2) * 100
			style.curve.attack = read_float(line, 7, 3)
			style.curve.decay = read_float(line, 11, 3)
			style.curve.sustain = read_float(line, 15, 3)
			style.curve.release = read_float(line, 19, 3)
			style.curve.cutoff = read_float(line, 23, 3)

			loader.styles[loader.styles_len] = style
			loader.styles_len += 1
		case MusicLoadState.MELODY:
			push_note_from_line(line, &loader, &result.tracks[1])
		case MusicLoadState.HARMONY:
			push_note_from_line(line, &loader, &result.tracks[2])
		}
	}

	result.length = result.tracks[1].absolute_length
	if result.tracks[2].absolute_length > result.length {
		result.length = result.tracks[2].absolute_length
	}

	fmt.println("Music loaded:", fname)
	fmt.println("  Length:", result.length)
	fmt.println("  track1:", result.tracks[1].notes_len)
	fmt.println("  track2:", result.tracks[2].notes_len)
}

@(private="file")
push_note_from_line :: proc(line: string, loader: ^MusicLoadContext, track: ^NoteTrack) {
	// Read line
	note_letter: u8 = line[0]
	silent: bool = false
	octave: f32 = 0
	sharp_offset: int = 0

	if note_letter == 'S' {
		silent = true
	} else {
		// -4 so that octave represents an offset from octave 4 (C4 to B4)
		octave_char, ok := strings.substring(line, 1, 2)
		if !ok {
			fmt.println("Could not get substring for octave_char. Music data corrupted.")
			os.exit(1)
		}
		octave = f32(strconv.atof(octave_char) - 4)

		if line[2] == '#' {
			sharp_offset = 1
		}
	}

	length_letter: u8 = line[4]
	dotted: bool = (line[5] == '.')
	style_index_char, ok := strings.substring(line, 7, 8)
		if !ok {
			fmt.println("Could not get substring for octave_char. Music data corrupted.")
			os.exit(1)
		}
	style_index: int = strconv.atoi(style_index_char)

	// Interpret data
	if style_index >= loader.styles_len {
		fmt.println("Trying to access a style outside the bounds of those setup. Music data corrupted.")
		fmt.println("  style_index:", style_index)
		fmt.println("  styles_len:", loader.styles_len)
		os.exit(1)
	}
	style: NoteSettings = loader.styles[style_index]

	note: Note
	note.amplitude = style.amplitude
	note.curve = style.curve

	freq_index: int
	if note_letter == 'C' {
		freq_index = 0
	} else if note_letter == 'D' {
		freq_index = 2
	} else if note_letter == 'E' {
		freq_index = 4
	} else if note_letter == 'F' {
		freq_index = 5
	} else if note_letter == 'G' {
		freq_index = 7
	} else if note_letter == 'A' {
		freq_index = 9
	} else if note_letter == 'B' {
		freq_index = 11
	}
	freq_index += sharp_offset // sharp_offset is 0 if note is not sharp

	frequencies: [13]f32 = {
		261.63, // C4
		277.18, // C#4
		293.66, // D4
		311.13, // D#4
		329.63, // E4
		349.23, // F4
		369.99, // F#4
		392.00, // G4
		415.30, // G#4
		440.00, // A4
		466.16, // A#4
		493.88, // B4
		523.25, // C5 (in case the mythical B# is invoked)
	}

	octave += style.octave_offset
	note.frequency = frequencies[freq_index] * math.pow_f32(2, octave)

	length: f32 = 0
	switch length_letter {
	case 'S':
		length = 1
	case 'E':
		length = 2
	case 'Q':
		length = 4
	case 'H':
		length = 8
	case 'W':
		length = 16
	}

	if dotted {
		length *= 1.5
	}

	if silent {
		note.amplitude = 0
		note.frequency = 0
		note.curve.attack = 0
		note.curve.decay = 0
		note.curve.sustain = 0
		note.curve.release = 0
		note.curve.cutoff = 0
	}

	note.timestamp = track.absolute_length 
	track.absolute_length += length
	track.notes[track.notes_len - 1] = note

	// We need an empty note at the end of the track
	empty_note: Note
	empty_note.timestamp = track.absolute_length
	empty_note.amplitude = 0

	track.notes[track.notes_len] = empty_note
	track.notes_len += 1
}

@(private="file")
read_float :: proc(str: string, start: int, digits: int) -> f32 {
	str, ok := strings.substring(str, start, start + digits)
	if !ok {
		fmt.println("Error reading float while loading track. Music data corrupted.")
		os.exit(1)
	}
	return f32(strconv.atof(str)) / 100
}

@(private="file")
get_music_fname :: proc(index: int) -> string {
	fname := strings.builder_make()
	strings.write_string(&fname, MUSIC_FNAME_PREFIX)
	strings.write_int(&fname, index)
	strings.write_string(&fname, ".mus")
	return strings.to_string(fname)
}
