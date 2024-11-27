package main

Sequence :: struct {
	starting_frame: IRect,
	num_frames: int,
	origin: IVec2,
	frame_length: f32,
}

Animator :: struct {
	sequence: ^Sequence,
	frame: int,
	time_to_next_frame: f32,
	frame_length_mod: f32,
	invisible: bool,
	flipped: bool,
}

cycle_and_draw_animator :: proc(animator: ^Animator, position: IVec2, platform: ^Platform, dt: f32) {
	using animator

	if frame_length_mod == 0 do frame_length_mod = 1

	time_to_next_frame -= dt
	if time_to_next_frame < 0 {
		time_to_next_frame = sequence.frame_length * frame_length_mod
		frame += 1
	}

	if frame >= sequence.num_frames {
		frame = 0
	}

	buffer_animator_sprite(animator, position, platform)
}

@(private="file")
buffer_animator_sprite :: proc(animator: ^Animator, position: IVec2, platform: ^Platform) {
	using animator

	src := sequence.starting_frame
	src.position.x += sequence.starting_frame.size.x * frame

	buffer_sprite(platform, src, position, sequence.origin, flipped)
}
