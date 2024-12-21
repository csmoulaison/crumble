package main
import "core:os"
import "core:fmt"

handle_waiting_to_start :: proc(session: ^Session, input: ^Input, sound_system: ^SoundSystem, dt: f32) {
	session.time_to_next_state -= dt
	if session.time_to_next_state < 0 {
		session.time_to_next_state = 0
	}

	if input.jump.just_pressed {
		start_music(session.current_level, sound_system)
		session.state = SessionState.LEVEL_ACTIVE
	}
}
