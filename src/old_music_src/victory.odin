music_victory :: proc() -> MusicData {
	melody: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.35
	settings.curve = {0.2, 3, 0.075, 0.2, -1}
	settings.octave_offset = 1

	accent: NoteSettings = settings
	accent.amplitude = 0.4

    // 1-4
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.DOT_HALF, settings)

    // 5-8
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.DOT_HALF, settings)

    // 9-12
    push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.DOT_HALF, settings)

    // 13-16
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.DOT_HALF, settings)

    // 17-20
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.DOT_HALF, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.DOT_HALF, settings)

    // 21-24
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.DOT_HALF, settings)

    // 25-28
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.DOT_HALF, settings)

	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.DOT_HALF, settings)

    // 29-32
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.DOT_HALF, settings)

    settings.octave_offset = -0.5

    // 33-36
    push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.DOT_HALF, settings)

    // 37-40
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.SIXTEENTH, settings)
    settings.octave_offset = 1
	push_note(&melody, NoteLetter.G5, NoteLength.SIXTEENTH, settings)

    // 41-44
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.SIXTEENTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.SIXTEENTH, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.DOT_HALF, settings)

    // 45-48
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.DOT_HALF, settings)


    // HARMONY
	harmony: NoteTrack = init_track()

    track_length: f32 = melody.absolute_length
	if harmony.absolute_length > track_length {
		track_length = harmony.absolute_length
	}

    settings.amplitude -= 0.05
    settings.octave_offset = 0
	settings.curve = {0.3, 3.5, 0.2, 0.2, -1}

    // 1-4
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 5-8
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 9-12
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 13-16
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 17-20
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 21-24
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 25-28
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 29-32
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 33-36
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 37-40
	push_note(&harmony, NoteLetter.D4, NoteLength.DOT_HALF, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.DOT_HALF, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.DOT_HALF, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 41-44
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

    // 45-48
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
    
	push_note(&harmony, NoteLetter.D4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	data: MusicData
	data.tempo = 10
	data.tracks[0] = init_track()
	data.tracks[1] = melody
	data.tracks[2] = harmony
	return data
}
