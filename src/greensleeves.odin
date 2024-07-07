package main

music_greensleeves :: proc() -> MusicData {
	melody: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.2
	settings.curve = {0.2, 6, 0.075, -1, -1}
	settings.octave_offset = 1

	accent: NoteSettings = settings
	accent.amplitude = 0.4

	// Measures 1-8
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.HALF, accent)

	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.E4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.DOT_HALF, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.DOT_HALF, accent)

	// Measures 9-12
	push_note(&melody, NoteLetter.G5, NoteLength.DOT_HALF, accent)

	push_note(&melody, NoteLetter.G5, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G4, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E4, NoteLength.DOT_HALF, accent)

	// Measures 13-16
	
	push_note(&melody, NoteLetter.G5, NoteLength.DOT_HALF, accent)

	push_note(&melody, NoteLetter.G5, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.HALF, accent)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G4, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	
	push_note(&melody, NoteLetter.A4, NoteLength.DOT_HALF, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, accent)

	// HARMONY
	harmony: NoteTrack = init_track()
	settings.octave_offset = -0.5

	accent = settings
	accent.amplitude = 0.3
	
	settings.amplitude = 0
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	settings.amplitude = 0.2

	// Measure 1-4
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.F4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	// Measure 5-8
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.F4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.DOT_HALF, accent)

	// Measures 9-12

	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.G_SHARP5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	
	// Measures 13-16

	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.G_SHARP5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, accent)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E6, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.HALF, accent)

	track_length: f32 = melody.absolute_length
	if harmony.absolute_length > track_length {
		track_length = harmony.absolute_length
	}

	data: MusicData
	data.tempo = 12
	data.tracks[1] = melody
	data.tracks[0] = harmony
	data.tracks[2] = init_track()
	return data
}
