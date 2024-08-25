package main

music_islands :: proc() -> MusicData {
	melody: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.35
	settings.curve = {0.15, 5, 0.1, 0.2, -1}
	settings.octave_offset = 0

	accent: NoteSettings = settings
	accent.amplitude = 0.4

    // Pre-1
	push_note(&melody, NoteLetter.SILENT, NoteLength.WHOLE, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.WHOLE, settings)

    // 1-4
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

    // 5-8
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

    push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

    // 9-12
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

    // 13-16
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

    // 17-20
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

    // 21-24
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

    // 25-28
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.HALF, settings)

    // 29-32
    push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.HALF, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G5, NoteLength.DOT_QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.G4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)

    // 35-38
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.SILENT, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)

    // 39-41
	push_note(&melody, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.EIGHTH, settings)

	push_note(&melody, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.D5, NoteLength.EIGHTH, settings)
	push_note(&melody, NoteLetter.B4, NoteLength.QUARTER, settings)
	push_note(&melody, NoteLetter.A4, NoteLength.HALF, settings)

    // HARMONY
	harmony: NoteTrack = init_track()
	settings.octave_offset = -0.75

    settings_high := settings
	settings_high.octave_offset = 0

    settings_low := settings
	settings_low.octave_offset = -0.75

    // Pre-1
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

    // 1-4
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
    
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

    // 5-8
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)

    // 9-12
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings) // actually goes down

	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.A5, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings) 

	push_note(&harmony, NoteLetter.F_SHARP5, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G_SHARP5, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)

    // 13-16
	push_note(&harmony, NoteLetter.C5, NoteLength.HALF, settings_high)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.HALF, settings)

    // 17-20
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings) // actually goes down

	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings) 

	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings) 
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings) 

    // 21-24
	push_note(&harmony, NoteLetter.C5, NoteLength.HALF, settings_high)
	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.A4, NoteLength.HALF, settings)

    // 27-30
	push_note(&harmony, NoteLetter.E5, NoteLength.HALF, settings_high)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.G4, NoteLength.EIGHTH, settings_high)
	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.EIGHTH, settings_high)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.B4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.F_SHARP4, NoteLength.HALF, settings_high)
	push_note(&harmony, NoteLetter.G_SHARP4, NoteLength.HALF, settings_high)

    // 31-34
	push_note(&harmony, NoteLetter.E5, NoteLength.HALF, settings_high)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.EIGHTH, settings_high)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings_high)
	push_note(&harmony, NoteLetter.D5, NoteLength.EIGHTH, settings_high)
	push_note(&harmony, NoteLetter.E5, NoteLength.EIGHTH, settings_high)

	push_note(&harmony, NoteLetter.A4, NoteLength.DOT_HALF, settings_high)
	push_note(&harmony, NoteLetter.SILENT, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.WHOLE, settings_high)

	push_note(&harmony, NoteLetter.SILENT, NoteLength.WHOLE, settings_high)

    // 35-38
	push_note(&harmony, NoteLetter.E5, NoteLength.WHOLE, settings)

	push_note(&harmony, NoteLetter.E5, NoteLength.WHOLE, settings)

	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.G4, NoteLength.QUARTER, settings_high)
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings_high)

	push_note(&harmony, NoteLetter.E5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.C5, NoteLength.QUARTER, settings)

    // 39-40
	push_note(&harmony, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.E4, NoteLength.QUARTER, settings)
	push_note(&harmony, NoteLetter.D5, NoteLength.QUARTER, settings)

	push_note(&harmony, NoteLetter.C5, NoteLength.HALF, settings)
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
