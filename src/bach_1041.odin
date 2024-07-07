package main

music_bach1041 :: proc() -> MusicData {
	melody: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.35
	settings.curve = {0.2, 4, 0.05, 0.2, -1}
	settings.octave_offset = 1

	accent: NoteSettings = settings
	accent.amplitude = 0.4

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	// measures 1-6
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)

	// measures 7-13
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.DOT_HALF, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C6, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.DOT_HALF, settings)

	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.DOT_QUARTER, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_HALF, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.G5, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	// sheet music says D. uh... no?
	push_note(&melody, NoteLetter.D_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D_SHARP5, NoteLength.QUARTER, settings)


	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	// sheet music says c# or dflat. nope
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)

	// measures 14-20
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E4, NoteLength.HALF, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D6, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C6, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	// 15-21
	push_note(&melody, NoteLetter.C6, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.G_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)


	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)

	// 22-28
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

	harmony: NoteTrack = init_track()
	settings.curve = {0.2, 5, 0.05, 0.2, -1}
	settings.octave_offset = -0.5
	settings.amplitude = 0.25

	// measures 1-6
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G_SHARP5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	
	// measures 7-13
	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E6, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)

	// measures 14-20
	push_note(&harmony, NoteLetter.D_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C_SHARP5, NoteLength.EIGHTH, settings)
	// ?? D5 ??
	push_note(&harmony, NoteLetter.D_SHARP4, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.B4, NoteLength.DOT_EIGHTH, settings)
	push_note(&harmony, NoteLetter.C_SHARP5, NoteLength.DOT_EIGHTH, settings)
	push_note(&harmony, NoteLetter.D_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.EIGHTH, settings)

	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D_SHARP5, NoteLength.DOT_HALF, settings)
	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	
	// measures 21-27
	push_note(&harmony, NoteLetter.A5, NoteLength.DOT_HALF, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.E6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)

	// measures 28-34
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G_SHARP5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C6, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)

	// Measures 35-41
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G_SHARP5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.HALF, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)

	// Final
	push_note(&harmony, NoteLetter.A4, NoteLength.HALF, settings)

	track_length: f32 = melody.absolute_length
	if harmony.absolute_length > track_length {
		track_length = harmony.absolute_length
	}

	data: MusicData
	data.tempo = 14
	data.tracks[1] = melody
	data.tracks[0] = harmony
	data.tracks[2] = init_track()
	return data
}
