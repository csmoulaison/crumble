package main
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

frequencies :: [12]f32 = {
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

deserialize_music :: proc(result: ^MusicData, index: int) -> (ok: bool) {
    data, read_ok := os.read_entire_file(get_music_fname(index))
    if !read_ok {
       return false
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
			style.amp = read_float(line, 0, 3)
			style.octave = read_float(line, 5, 1)
			style.curve.attack = read_float(line, 7, 3)
			style.curve.decay = read_float(line, 11, 3)
			style.curve.sustain = read_float(line, 15, 3)
			style.curve.release = read_float(line, 19, 3)
			style.curve.cutoff = read_float(line, 23, 3)

			loader.styles[music.styles_len] = style
			loader.styles_len += 1
		case MusicLoadState.MELODY:
			note: Note = read_note(line)
			push_note(&result.tracks[1], note)
		case MusicLoadState.HARMONY:
			note: Note = read_note(line)
			push_note(&result.tracks[1], note)
		}
	}

	result.length: f32 = melody.absolute_length
	if harmony.absolute_length > result.length {
		result.length = harmony.absolute_length
	}

    return true
}

@(private="file")
read_note :: proc(line: ^string, loader: ^MusicLoadContext) -> Note {
	// Read line
	note_letter: rune = line[0]
	silent: bool = false
	octave: int = 0
	sharp_offset: int = 0

	if note_letter == 'S' {
		silent = true
	} else {
		// -4 so that octave represents an offset from octave 4 (C4 to B4)
		octave = strconv.atoi(line[1]) - 4
		if line[2] == '#' {
			sharp_offset = 1
		}
	}

	length_letter: rune = line[4]
	dotted: bool = (line[5] == '.')
	style_index: int = strconv.atoi(line[7])

	// Interpret data
	if style_index >= loader.styles_len {
		printf("Trying to access a style outside the bounds of those setup. Music data corrupted.")
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

	octave += style.octave_offset
	note.frequency = frequencies[freq_index] * math.pow_f32(2, octave)

	// TODO: Get note.timestamp. I think this is done in push_note at the moment.
	// This will also involve using the length letter we got earlier. Probs another
	// switch statement, but not with a separate table as with frequencies.
	// 
	// After that, everything in note is sorted.
	// 
	// Remember that it would be good to have as much done in here as possible, as
	// this function is called twice. It is a function after all. Thanks.
}

@(private="file")
read_float :: proc(str: string, start: int, digits: int) -> float {
	str, ok := substring(line, start, start + digits)
	if(!ok) {
		fmt.println("Error: Couldn't read float for music style. Music data is corrupt.")
		os.exit(1)
	}
	return strconv.atof(str)
}

@(private="file")
get_music_fname :: proc(index: int) -> string {
	fname := strings.builder_make()
	strings.write_string(&fname, MUSIC_FNAME_PREFIX)
	strings.write_int(&fname, index)
	strings.write_string(&fname, ".mus")
	return strings.to_string(fname)
}
