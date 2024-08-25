package main

SoundSystem :: struct {
	channels: [OSCILLATORS_LEN]SoundChannel,
	music_trackhead: Trackhead,
	music_length: f32,
	music_tempo: f32,
}

update_sound_system :: proc(sound_system: ^SoundSystem, audio: ^Audio, dt: f32) {
	using sound_system

	tempo: f32 = dt * music_tempo
	music_trackhead.position += tempo
	if music_trackhead.position > music_length {
		music_trackhead.position = music_trackhead.position - music_length
		music_trackhead.position = 0
	}

	// Sound channel
	update_channel(&channels[0], &music_trackhead, audio, music_length, 0, tempo, dt)
	// Music channel
	update_channel(&channels[1], &music_trackhead, audio, music_length, 1, tempo, dt)
    // Music channel 2
	update_channel(&channels[2], &music_trackhead, audio, music_length, 2, tempo, dt)
}
