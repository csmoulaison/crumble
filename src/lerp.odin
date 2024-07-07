package main

lerp :: proc(a: f32, b: f32, t: f32) -> f32 {
	return (1 - t) * a + t * b;
}
