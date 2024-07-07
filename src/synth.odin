package main
import MA "vendor:miniaudio"
import "core:fmt"
import "core:mem"

MAX_TRACK_STATES :: 512
OSCILLATORS_LEN :: 3
NOISE_GENERATORS_LEN :: 1

Audio :: struct {
	device: MA.device,
	device_config: MA.device_config,

	data: AudioData,
	oscillator_configs: [OSCILLATORS_LEN]MA.waveform_config,
	noise_generator_configs: [NOISE_GENERATORS_LEN]MA.noise_config,
}

AudioData :: struct {
	oscillators: [OSCILLATORS_LEN]MA.waveform,
	noise_generators: [NOISE_GENERATORS_LEN]MA.noise,
}

init_audio :: proc(audio: ^Audio) {
	using audio

	device_config = MA.device_config_init(MA.device_type.playback)
	device_config.playback.format = MA.format.f32
	device_config.playback.channels = 1
	device_config.sampleRate = 96000
	device_config.dataCallback = audio_data_callback
	device_config.pUserData = &data

	if MA.device_init(nil, &device_config, &device) != MA.result.SUCCESS {
		fmt.println("Failed to open playback device")
		return
	}
	else {
		fmt.println("Successfully opened playback device")
	}

	for &oscillator, i in data.oscillators {
		waveform_type := MA.waveform_type.square
		if i == 1 {
			waveform_type = MA.waveform_type.sawtooth
		}
		if i == 2 {
			waveform_type = MA.waveform_type.square
		}

		oscillator_configs[i] = MA.waveform_config_init(
			device.playback.internalFormat, 
			device.playback.channels, 
			device.sampleRate, 
			waveform_type,
			0, 
			0)
		MA.waveform_init(&oscillator_configs[i], &oscillator)
	}

	if MA.device_start(&device) != MA.result.SUCCESS {
		fmt.println("Failed to start playback device")
		MA.device_uninit(&device)
	}
	else {
		fmt.println("Successfully started playback device")
	}
}

audio_data_callback :: proc "c" (device: ^MA.device, output, input: rawptr, frame_count: u32) {
	data := (^AudioData)(device.pUserData)
	output_f32 := (^f32)(output)
	output_buffer: [4096]f32

	for &oscillator in data.oscillators {
		MA.waveform_read_pcm_frames(&oscillator, &output_buffer, u64(frame_count / 2), nil)

		for i: u64 = 0; i < u64(frame_count) * 2; i += 1 {
			mem.ptr_offset(output_f32, i * 2)^ += output_buffer[i]
		}
	}
}

set_amplitude :: proc(oscillator: ^MA.waveform, amp: f32) {
	MA.waveform_set_amplitude(oscillator, f64(amp))
}

set_frequency :: proc(oscillator: ^MA.waveform, freq: f32) {
	MA.waveform_set_frequency(oscillator, f64(freq))
}
