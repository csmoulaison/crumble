package main
import MA "vendor:miniaudio"
import "core:fmt"
import "core:mem"
import "core:strings"
import "core:math"
import "core:math/rand"

MAX_TRACK_STATES :: 512
OSCILLATORS_LEN :: 3
NOISE_GENERATORS_LEN :: 1
SIN_LUT_LEN :: 1000

Audio :: struct {
	device: MA.device,
	device_config: MA.device_config,

	data: AudioData,
	oscillator_configs: [OSCILLATORS_LEN]MA.waveform_config,
	noise_generator_configs: [NOISE_GENERATORS_LEN]MA.noise_config,
}

AudioData :: struct {
	osc_backends: [OSCILLATORS_LEN]MA.waveform,
	noise_generators: [NOISE_GENERATORS_LEN]MA.noise,
    oscillators: [OSCILLATORS_LEN]Oscillator,
    sin_lut: [SIN_LUT_LEN]f32,
}

Oscillator :: struct {
    frequency: i16,
    target_frequency: i16,
    amplitude: f32,
    target_amplitude: f32,
    t: f32
}

init_audio :: proc(audio: ^Audio) {
	using audio

	device_config = MA.device_config_init(MA.device_type.playback)
	device_config.playback.format = MA.format.f32
	device_config.playback.channels = 1
	device_config.sampleRate = 48000
	device_config.dataCallback = audio_data_callback
	device_config.pUserData = &data

	if MA.device_init(nil, &device_config, &device) != MA.result.SUCCESS {
		fmt.println("Failed to open playback device")
		return
	} else {
		fmt.println("Successfully opened playback device")
	}

	for &osc_backend, i in data.osc_backends {
		waveform_type := MA.waveform_type.square

		oscillator_configs[i] = MA.waveform_config_init(
			device.playback.internalFormat, 
			device.playback.channels, 
			device.sampleRate, 
			waveform_type,
			0, 
			0)
		MA.waveform_init(&oscillator_configs[i], &osc_backend)
	}

	if MA.device_start(&device) != MA.result.SUCCESS {
		fmt.println("Failed to start playback device")
		MA.device_uninit(&device)
	} else {
		fmt.println("Successfully started playback device")
	}
}

audio_data_callback :: proc "c" (device: ^MA.device, output, input: rawptr, frame_count: u32) {
	data := (^AudioData)(device.pUserData)
	output_f32 := (^f32)(output)
	output_buffer: [2048]f32

    MA.waveform_read_pcm_frames(&data.osc_backends[0], &output_buffer, u64(frame_count), nil)

	for i := 0; i < OSCILLATORS_LEN - 0; i += 1 {
        t_add := (1.0 / 48000.0) * f32(data.oscillators[i].frequency)
		for j: u64 = 0; j < u64(frame_count); j += 1 {
            if data.oscillators[i].target_amplitude > data.oscillators[i].amplitude do data.oscillators[i].amplitude += 0.02
            else if data.oscillators[i].target_amplitude < data.oscillators[i].amplitude do data.oscillators[i].amplitude -= 0.02

            data.oscillators[i].t += t_add
            sin_index := data.oscillators[i].t

            // for square
            if (i == 0 && int(data.oscillators[i].t) % 2 == 0) || (i != 0 && int(data.oscillators[i].t * 2) % 4 == 0) {
                mem.ptr_offset(output_f32, j )^ += data.oscillators[i].amplitude
            } else {
                mem.ptr_offset(output_f32, j )^ -= data.oscillators[i].amplitude
            }

            if mem.ptr_offset(output_f32, j )^ < -0.999 do mem.ptr_offset(output_f32, j )^ = -0.999
            else if mem.ptr_offset(output_f32, j )^ > 0.999 do mem.ptr_offset(output_f32, j )^ = 0.999
		}

        // for square
        if data.oscillators[i].t > 64 {
            data.oscillators[i].t -= 64
        }
	}
}

set_amplitude :: proc(oscillator: ^Oscillator, amp: f32) {
if amp > 0 {
    oscillator.target_amplitude = amp + f32(rand.int_max(1000)) / 50000 - 500 / 50000
} else {
	oscillator.target_amplitude = 0
}
}

set_frequency :: proc(oscillator: ^Oscillator, freq: f32) {
    oscillator.frequency = i16(freq) + i16(rand.int_max(1000)) / 500 - 500 / 500
}
