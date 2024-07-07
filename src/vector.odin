package main

Vec2 :: [2]f32
IVec2 :: [2]int

ivec2_from_vec2 :: proc(v: Vec2) -> IVec2 {
	return IVec2{int(v.x), int(v.y)}
}
