package main

MusicData :: struct {
	tracks: [OSCILLATORS_LEN]NoteTrack,
	length: f32,
	tempo: f32,
}

init_track :: proc() -> NoteTrack {
	track: NoteTrack
	track.absolute_length = 0

	note: Note
	note.amplitude = 0
	note.timestamp = 0

	track.notes[0] = note
	track.notes_len = 1

	return track
}

start_music :: proc(music: MusicData, sound_system: ^SoundSystem) {
	longest_track_length: f32 = 0
	for i := 0; i < 3; i += 1 {
		sound_system.channels[i].music.track = music.tracks[i]
		if music.tracks[i].absolute_length > longest_track_length {
			longest_track_length = music.tracks[i].absolute_length
		}
	}

	sound_system.music_length = longest_track_length
	sound_system.music_tempo = music.tempo
	sound_system.music_trackhead.position = 0
}

stop_music :: proc(sound_system: ^SoundSystem) {
	using sound_system

	channels[0].music.track = init_track()
	channels[1].music.track = init_track()
	channels[2].music.track = init_track()

	music_length = 0
	music_trackhead.position = 0
}

track_king_die :: proc() -> NoteTrack {
	track: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.4
	settings.curve = {-1, -1, 0.25, -1, 0.5}

	push_note(&track, NoteLetter.A4, NoteLength.HALF, settings)
	push_note(&track, NoteLetter.A5, NoteLength.QUARTER, settings)
	push_note(&track, NoteLetter.A3, NoteLength.QUARTER, settings)

	return track
}

track_game_over :: proc() -> NoteTrack {
	track: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.4
	settings.curve = {-1, -1, 0.25, -1, 0.5}

	push_note(&track, NoteLetter.A4, NoteLength.HALF, settings)
	push_note(&track, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&track, NoteLetter.A4, NoteLength.QUARTER, settings)
	
	return track
}

track_food_cooking :: proc() -> NoteTrack {
	track: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.4
	settings.curve = {-1, -1, 0.25, -1, 0.5}

	push_note(&track, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&track, NoteLetter.B4, NoteLength.EIGHTH, settings)
	push_note(&track, NoteLetter.C5, NoteLength.EIGHTH, settings)
	push_note(&track, NoteLetter.G5, NoteLength.HALF, settings)

	return track
}

track_food_appear :: proc() -> NoteTrack {
	track: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.4
	settings.curve = {-1, -1, 0.25, -1, 0.5}

	push_note(&track, NoteLetter.A3, NoteLength.EIGHTH, settings)
	push_note(&track, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&track, NoteLetter.A5, NoteLength.EIGHTH, settings)

	return track
}

track_food_disappear :: proc() -> NoteTrack {
	track: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.4
	settings.curve = {-1, -1, 0.25, -1, 0.5}

	push_note(&track, NoteLetter.A4, NoteLength.QUARTER, settings)
	push_note(&track, NoteLetter.A3, NoteLength.QUARTER, settings)

	return track
}

track_food_eat :: proc() -> NoteTrack {
	track: NoteTrack = init_track()

	settings: NoteSettings
	settings.amplitude = 0.4
	settings.curve = {-1, -1, 0.25, -1, 0.5}

	push_note(&track, NoteLetter.A4, NoteLength.DOT_SIXTEENTH, settings)
	push_note(&track, NoteLetter.B4, NoteLength.DOT_SIXTEENTH, settings)
	push_note(&track, NoteLetter.C5, NoteLength.DOT_SIXTEENTH, settings)
	push_note(&track, NoteLetter.G5, NoteLength.QUARTER, settings)
	push_note(&track, NoteLetter.A4, NoteLength.EIGHTH, settings)
	push_note(&track, NoteLetter.G5, NoteLength.QUARTER, settings)

	return track
}
