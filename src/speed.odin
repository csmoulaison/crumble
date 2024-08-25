package main

music_speed :: proc() -> MusicData {
	melody: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.3
	settings.curve = {0.2, 5, 0.05, -1, -1}
	settings.octave_offset = 1

	accent: NoteSettings = settings
	accent.amplitude = 0.4

	// 1
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, accent)

	push_note(&melody, NoteLetter.E5, NoteLength.DOT_HALF, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	
	// 5
	push_note(&melody, NoteLetter.B4, NoteLength.DOT_HALF, accent)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, accent)

	push_note(&melody, NoteLetter.E5, NoteLength.DOT_HALF, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.WHOLE, accent)

	//10
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, accent)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, accent)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, accent)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, accent)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, accent)
	push_note(&melody, NoteLetter.D5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.C_SHARP5, NoteLength.QUARTER, settings)

	// 13
	push_note(&melody, NoteLetter.D5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	// 16
	push_note(&melody, NoteLetter.C5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

	// 20
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

	harmony: NoteTrack = init_track()
	settings.octave_offset = -0.5
	settings.amplitude = 0.2

	// 1
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.DOT_HALF, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	// 5
	push_note(&harmony, NoteLetter.E5, NoteLength.DOT_HALF, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.DOT_HALF, settings)
	push_note(&harmony, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.WHOLE, settings)

	// 10
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.EIGHTH, settings)
	
	push_note(&harmony, NoteLetter.E5, NoteLength.DOT_HALF, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.DOT_QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	// 13
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.HALF, settings)

	// 16
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.DOT_QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.E5, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)

	// 20
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.HALF, settings)

	track_length: f32 = melody.absolute_length
	if harmony.absolute_length > track_length {
		track_length = harmony.absolute_length
	}

	data: MusicData
	data.tempo = 13
	data.tracks[0] = init_track()
	data.tracks[1] = melody
	data.tracks[2] = harmony
	return data
}
