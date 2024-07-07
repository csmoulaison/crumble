package main
import "core:time"
import "core:fmt"

Clock :: struct {
	tick: time.Tick,
	dt: f32,
}

init_clock :: proc(clock: ^Clock) {
	clock.tick = time.tick_now()
}

update_clock :: proc(clock: ^Clock) {
	current_tick: time.Tick = time.tick_now()
	clock.dt = f32(time.duration_seconds(time.tick_diff(clock.tick, current_tick)))
	clock.tick = current_tick
}
