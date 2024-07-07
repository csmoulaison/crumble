package main
import "core:math"

ROOT_FREQ :: 440.00
DEFAULT_AMPLITUDE :: 0.2 // absolute
DEFAULT_ATTACK :: 0.2
DEFAULT_DECAY :: 4
DEFAULT_SUSTAIN :: 0.25 // relative
DEFAULT_RELEASE :: 0.01 // relative
DEFAULT_CUTOFF :: 1 // relative

SoundChannel :: struct {
	music: SoundState,
	sound: SoundState,
	sound_playing: bool,
}

SoundState :: struct {
	trackhead: Trackhead,
	track: NoteTrack,
	note_just_changed: bool,

	type: SoundType,
	frequency: f32,
	amplitude: f32,
	speed: f32, // speed through t
	t: f32, // normalized time 0 to 1
	elapsed: f32, // absolute time passed in seconds
}

SoundType :: enum {
	TRACK,
	NAVIGATE,
	SELECT,
	GO_BACK,

	JUMP,
	FLOAT,
	FOOD_BLINK,
	FOOD_COOKING,

	FOOD_APPEAR,
	FOOD_DISAPPEAR,
	FOOD_EAT,
	ENEMY_ALARMED,

	ENEMY_LOST,
	KING_DIE,
	GAME_OVER,
	POT_BOUNCE,
}


Note :: struct {
	amplitude: f32,
	frequency: f32,
	timestamp: f32,
	curve: ADSRCurve,
}

NoteTrack :: struct {
	notes: [MAX_TRACK_STATES]Note,
	notes_len: int,
	absolute_length: f32,
	priority: int,
}

NoteSettings :: struct {
	amplitude: f32,
	curve: ADSRCurve,
	octave_offset: f32,
}

NoteLetter :: enum {
	SILENT,
	A3,
	E4,
	F4,
	F_SHARP4,
	G4,
	G_SHARP4,
	A4,
	A_SHARP4,
	B4,
	C4,
	D4,
	D_SHARP4,
	C5,
	C_SHARP5,
	D5,
	D_SHARP5,
	E5,
	F5,
	F_SHARP5,
	G5,
	G_SHARP5,
	A5,
	A_SHARP5,
	B5,
	C6,
	D6,
	E6,
}

NoteLength :: enum {
	SIXTEENTH,
	DOT_SIXTEENTH,
	EIGHTH,
	DOT_EIGHTH,
	QUARTER,
	DOT_QUARTER,
	HALF,
	DOT_HALF,
	WHOLE,
	DOT_WHOLE,
}

ADSRCurve :: struct {
	attack: f32,
	decay: f32,
	sustain: f32,
	release: f32,
	cutoff: f32,
}

Trackhead :: struct {
	position: f32,
}

start_track :: proc(channel: ^SoundChannel, new_track: NoteTrack, fg: bool) {
	using channel.sound

	if new_track.notes_len <= 0 {
		return
	}

	track = new_track
	trackhead.position = 0

	start_sound(channel, SoundType.TRACK)

	// VOLATILE this is set because start_sound sets sound_playing to true
	channel.sound_playing = fg
}

start_sound :: proc(channel: ^SoundChannel, new_type: SoundType) {
	if channel.sound.type != SoundType.POT_BOUNCE && 
	new_type != SoundType.POT_BOUNCE &&
	channel.sound_playing &&
	channel.sound.type == SoundType.TRACK &&
	(new_type != SoundType.KING_DIE ||
	new_type != SoundType.GAME_OVER ||
	new_type != SoundType.FOOD_COOKING ||
	new_type != SoundType.FOOD_APPEAR ||
	new_type != SoundType.FOOD_DISAPPEAR ||
	new_type != SoundType.FOOD_EAT) {
		return
	}

	channel.sound_playing = true
	using channel.sound

	type = new_type
	t = 0
	elapsed = 0
	amplitude = 0.4

	switch type {
	case SoundType.TRACK:
	case SoundType.NAVIGATE:
		speed = 24
		frequency = ROOT_FREQ * 2
	case SoundType.SELECT:
		speed = 8
		frequency = ROOT_FREQ
	case SoundType.GO_BACK:
		speed = 16
		frequency = ROOT_FREQ * 0.25
	case SoundType.JUMP:
		speed = 12
		frequency = 600
	case SoundType.FLOAT:
		speed = 3
		frequency = 600
	case SoundType.FOOD_BLINK:
		frequency = ROOT_FREQ * 2
		speed = 16
	case SoundType.FOOD_COOKING:
		start_track(channel, track_food_cooking(), true)
	case SoundType.FOOD_APPEAR:
		start_track(channel, track_food_appear(), true)
	case SoundType.FOOD_DISAPPEAR:
		start_track(channel, track_food_disappear(), true)
	case SoundType.FOOD_EAT:
		start_track(channel, track_food_eat(), true)
	case SoundType.ENEMY_ALARMED:
		frequency = ROOT_FREQ
		speed = 4
	case SoundType.ENEMY_LOST:
		frequency = ROOT_FREQ
		speed = 4
	case SoundType.KING_DIE:
		start_track(channel, track_king_die(), true)
	case SoundType.GAME_OVER:
		start_track(channel, track_game_over(), true)
	case SoundType.POT_BOUNCE:
		frequency = ROOT_FREQ
		speed = 0.5
	}
}

update_channel :: proc(channel: ^SoundChannel, global_trackhead: ^Trackhead, audio: ^Audio, track_length: f32, oscillator_index: int, tempo: f32, dt: f32) {
	update_track(&channel.music, global_trackhead, audio, oscillator_index, tempo)

	if channel.sound_playing {
		if update_sound(&channel.sound, audio, oscillator_index, dt) {
			channel.sound_playing = false
		}
	}
}

update_track :: proc(sound: ^SoundState, global_trackhead: ^Trackhead, audio: ^Audio, oscillator_index: int, dt: f32) -> (finished: bool) {
	using sound
	oscillator := &audio.data.oscillators[oscillator_index]

	current_note := &track.notes[0]
	current_i := 0
	note_elapsed: f32 = 0
	note_length: f32 = 0
	note_t: f32 = 0

	if global_trackhead.position < track.notes[1].timestamp {
		current_note = &track.notes[0]
		note_elapsed = global_trackhead.position
		note_length = track.notes[1].timestamp
	}
	else {
		for n, i in track.notes[:track.notes_len] {
			if global_trackhead.position < track.notes[i].timestamp {
				current_note = &track.notes[i - 1]
				note_elapsed = global_trackhead.position - current_note.timestamp
				note_length = track.notes[i].timestamp - current_note.timestamp

				current_i = i
				break
			}
		}
	}

	note_t = note_elapsed / note_length

	set_amplitude(oscillator, adsr_amplitude(current_note, note_elapsed, note_t))
	set_frequency(oscillator, current_note.frequency)

	return 
}

update_sound :: proc(sound: ^SoundState, audio: ^Audio, oscillator_index: int, dt: f32) -> (sound_finished: bool) {
	using sound
	oscillator := &audio.data.oscillators[oscillator_index]

	// SFX
	#partial switch type {
	case SoundType.TRACK:
		sound.trackhead.position += dt * 16
		update_track(sound, &sound.trackhead, audio, oscillator_index, dt)
	case SoundType.NAVIGATE:
		set_frequency(oscillator, frequency)
		set_amplitude(oscillator, amplitude)	
	case SoundType.SELECT:
		if t < 0.5 {
			set_frequency(oscillator, frequency)
		}
		else {
			set_frequency(oscillator, frequency * 0.5)
		}

		set_amplitude(oscillator, amplitude)	
	case SoundType.GO_BACK:
		set_frequency(oscillator, frequency)
		set_amplitude(oscillator, amplitude)
	case SoundType.JUMP:
		frequency += 3200 * dt

		set_frequency(oscillator, frequency)
		set_amplitude(oscillator, amplitude)
	case SoundType.FLOAT:
		// Frequency modulated in king jump control function
		//frequency += 800 * dt
		amplitude = 0.6 - (0.5 * t)

		set_frequency(oscillator, frequency)
		set_amplitude(oscillator, amplitude)
	case SoundType.FOOD_BLINK:
		set_frequency(oscillator, frequency)
		set_amplitude(oscillator, amplitude)
	case SoundType.ENEMY_ALARMED:
		lfo := math.sin_f32(t * 18)
		set_frequency(oscillator, frequency + lfo * 400 + t * 400)
		set_amplitude(oscillator, amplitude - 0.25 + lfo * 0.25)
	case SoundType.ENEMY_LOST:
		lfo := math.sin_f32(t * 18)
		set_frequency(oscillator, frequency + lfo * 400 - t * 400)
		set_amplitude(oscillator, amplitude - 0.25 + lfo * 0.25)
	case SoundType.POT_BOUNCE:
		attack: f32 = 0.06
		if t < attack {
			set_amplitude(oscillator, lerp(amplitude * 1.5, amplitude, t / attack))
			set_frequency(oscillator, lerp(frequency * 2, frequency, t / attack))
		}
		else {
			lfo := math.sin_f32(t * 32)
			set_frequency(oscillator, frequency + frequency * t * 5 + lfo * 25)
			set_amplitude(oscillator, amplitude + amplitude * -t)
		}
	}

	elapsed += dt

	if type == SoundType.TRACK && sound.trackhead.position > sound.track.absolute_length {
		// Track finished = sound finished
		return true
	}

	t += speed * dt
	if type != SoundType.TRACK && t > 1 {
		// Sound finished
		return true
	}


	return false
}

adsr_amplitude :: proc(note: ^Note, elapsed: f32, t: f32) -> f32 {
	absolute_sustain: f32 = note.amplitude * note.curve.sustain

	if t > note.curve.cutoff {
		if t > note.curve.cutoff + note.curve.release {
			return 0
		}

		return lerp(
			note.curve.sustain,
			0,
			(t - note.curve.cutoff) / note.curve.release)
	}
	
	if elapsed < note.curve.attack {
		return lerp(
			0, 
			note.amplitude, 
			elapsed / note.curve.attack)
	} 
	else if elapsed - note.curve.attack < note.curve.decay {
		return lerp(
			note.amplitude, 
			absolute_sustain,
			(elapsed - note.curve.attack) / note.curve.decay)
	}

	return absolute_sustain
}

push_note :: proc(track: ^NoteTrack, letter: NoteLetter, length: NoteLength, settings: NoteSettings) {
	note: Note

	amplitude := settings.amplitude
	adsr := settings.curve

	if amplitude == -1 {
		note.amplitude = DEFAULT_AMPLITUDE
	}
	else {
		note.amplitude = amplitude
	}

	if adsr.attack == -1 {
		note.curve.attack = DEFAULT_ATTACK
	}
	else {
		note.curve.attack = adsr.attack
	}

	if adsr.decay == -1 {
		note.curve.decay = DEFAULT_DECAY
	}
	else {
		note.curve.decay = adsr.decay
	}

	if adsr.sustain == -1 {
		note.curve.sustain = DEFAULT_SUSTAIN
	}
	else {
		note.curve.sustain = adsr.sustain
	}

	if adsr.release == -1 {
		note.curve.release = DEFAULT_RELEASE
	}
	else {
		note.curve.release = adsr.release
	}

	if adsr.cutoff == -1 {
		note.curve.cutoff = DEFAULT_CUTOFF
	}
	else {
		note.curve.cutoff = adsr.cutoff
	}

	switch letter {
	case NoteLetter.SILENT:
		note.amplitude = 0
	case NoteLetter.A3:
		note.frequency = 220.00
	case NoteLetter.C4:
		note.frequency = 261.63 
	case NoteLetter.D4:
		note.frequency = 293.66
	case NoteLetter.D_SHARP4:
		note.frequency = 311.13
	case NoteLetter.E4:
		note.frequency = 329.63
	case NoteLetter.F4:
		note.frequency = 349.23
	case NoteLetter.F_SHARP4:
		note.frequency = 369.99
	case NoteLetter.G4:
		note.frequency = 392
	case NoteLetter.G_SHARP4:
		note.frequency = 415.30
	case NoteLetter.A4:
		note.frequency = 440
	case NoteLetter.A_SHARP4:
		note.frequency = 466.16
	case NoteLetter.B4:
		note.frequency = 493.88
	case NoteLetter.C5:
		note.frequency = 523.25
	case NoteLetter.C_SHARP5:
		note.frequency = 554.37
	case NoteLetter.D5:
		note.frequency = 587.33
	case NoteLetter.D_SHARP5:
		note.frequency = 622.25
	case NoteLetter.E5:
		note.frequency = 659.25
	case NoteLetter.F5:
		note.frequency = 698.46
	case NoteLetter.F_SHARP5:
		note.frequency = 739.99
	case NoteLetter.G5:
		note.frequency = 783.99
	case NoteLetter.G_SHARP5:
		note.frequency = 830.61
	case NoteLetter.A5:
		note.frequency = 880.00
	case NoteLetter.A_SHARP5:
		note.frequency = 932.33
	case NoteLetter.B5:
		note.frequency = 987.77
	case NoteLetter.C6:
		note.frequency = 1046.50
	case NoteLetter.D6:
		note.frequency = 1174.66
	case NoteLetter.E6:
		note.frequency = 1318.51
	}

	note.frequency += note.frequency * settings.octave_offset

	note_absolute_length: f32 = 0
	switch length {
	case NoteLength.SIXTEENTH:
		note_absolute_length = 1
	case NoteLength.DOT_SIXTEENTH:
		note_absolute_length = 1.5
	case NoteLength.EIGHTH:
		note_absolute_length = 2
	case NoteLength.DOT_EIGHTH:
		note_absolute_length = 3
	case NoteLength.QUARTER:
		note_absolute_length = 4
	case NoteLength.DOT_QUARTER:
		note_absolute_length = 6
	case NoteLength.HALF:
		note_absolute_length = 8
	case NoteLength.DOT_HALF:
		note_absolute_length = 12
	case NoteLength.WHOLE:
		note_absolute_length = 16
	case NoteLength.DOT_WHOLE:
		note_absolute_length = 24
	}

	note.timestamp = track.absolute_length 
	track.absolute_length += note_absolute_length

	track.notes[track.notes_len - 1] = note

	empty_note: Note
	empty_note.timestamp = track.absolute_length
	empty_note.amplitude = 0

	track.notes[track.notes_len] = empty_note
	track.notes_len += 1
}
