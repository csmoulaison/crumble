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

start_music :: proc(level_index: int, sound_system: ^SoundSystem) {
	musics: [7]^MusicData = {
		&sound_system.music.bach_1067,
		&sound_system.music.dompe,
		&sound_system.music.bach_1041,
		&sound_system.music.bach_1041_2,
		&sound_system.music.greensleeves,
		&sound_system.music.islands,
		&sound_system.music.victory,
	};
	music: ^MusicData = musics[level_index]
	
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
