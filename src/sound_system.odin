package main

MusicTracks :: struct {
    greensleeves: MusicData,
    dompe: MusicData,
    bach_1041: MusicData,
    bach_1041_2: MusicData,
    speed: MusicData,
    ballard: MusicData,
    islands: MusicData,
    victory: MusicData,
    bach_1067: MusicData,

    track_startup: NoteTrack,
    track_food_appear: NoteTrack,
    track_food_cooking: NoteTrack,
    track_food_disappear: NoteTrack,
    track_food_eat: NoteTrack,
    track_game_over: NoteTrack,
    track_king_die: NoteTrack,
}

SoundSystem :: struct {
	channels: [OSCILLATORS_LEN]SoundChannel,
	music_trackhead: Trackhead,
	music_length: f32,
	music_tempo: f32,
	music: MusicTracks,
}

init_sound_system :: proc(sound_system: ^SoundSystem) {
	deserialize_music(&sound_system.music.speed, "music/music_speed.mus")
	deserialize_music(&sound_system.music.bach_1041, "music/music_bach_1041.mus")
	deserialize_music(&sound_system.music.islands, "music/music_islands.mus")
	deserialize_music(&sound_system.music.greensleeves, "music/music_greensleeves.mus")
	deserialize_music(&sound_system.music.bach_1041_2, "music/music_bach_1041_2.mus")
	deserialize_music(&sound_system.music.victory, "music/music_victory.mus")
	deserialize_music(&sound_system.music.bach_1067, "music/music_bach_1067.mus")
	deserialize_music(&sound_system.music.dompe, "music/music_dompe.mus")

	tmp: MusicData

	deserialize_music(&tmp, "music/track_startup.mus")
	sound_system.music.track_startup = tmp.tracks[1]

	deserialize_music(&tmp, "music/track_food_appear.mus")
	sound_system.music.track_food_appear = tmp.tracks[1]

	deserialize_music(&tmp, "music/track_food_cooking.mus")
	sound_system.music.track_food_cooking = tmp.tracks[1]

	deserialize_music(&tmp, "music/track_food_disappear.mus")
	sound_system.music.track_food_disappear = tmp.tracks[1]

	deserialize_music(&tmp, "music/track_food_eat.mus")
	sound_system.music.track_food_eat = tmp.tracks[1]

	deserialize_music(&tmp, "music/track_game_over.mus")
	sound_system.music.track_game_over= tmp.tracks[1]

	deserialize_music(&tmp, "music/track_king_die.mus")
	sound_system.music.track_king_die = tmp.tracks[1]
}

update_sound_system :: proc(sound_system: ^SoundSystem, audio: ^Audio, dt: f32) {
	using sound_system

	tempo: f32 = dt * music_tempo
	music_trackhead.position += tempo
	if music_trackhead.position > music_length {
		music_trackhead.position = music_trackhead.position - music_length
		music_trackhead.position = 0

		// DEBUG for music editing!
		//deserialize_music(&sound_system.music.bach_1041_2, "music/music_bach_1041_2.mus")
		//start_music(1, sound_system)
	}

	// Sound channel
	update_channel(&channels[0], &music_trackhead, audio, music_length, 0, tempo, dt)
	// Music channel
	update_channel(&channels[1], &music_trackhead, audio, music_length, 1, tempo, dt)
    // Music channel 2
	update_channel(&channels[2], &music_trackhead, audio, music_length, 2, tempo, dt)
}
