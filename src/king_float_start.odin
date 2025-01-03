package main
import "core:math"

move_king_float_start :: proc(time_to_next_state: f32, king: ^King, king_y_offset: ^f32, config: ^Config) -> (just_grounded: bool) {
    t: f32 = (config.pre_active_length - time_to_next_state * time_to_next_state * 0.5) + 0.05
    amplitude: f32 = 300
    if t < 2.0217 {
        king_y_offset^ = -((math.sin(t) * amplitude) - amplitude * 0.9)
        king.jump_state = JumpState.FLOAT
        if t > 1.65 {
            king.jump_state = JumpState.JUMP
        }
    } else {
	    if king.jump_state != JumpState.GROUNDED {
	        king.jump_state = JumpState.GROUNDED
	        return true
	    }
    }

    return false
}
