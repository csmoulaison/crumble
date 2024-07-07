package main

Rect :: struct {
	position: Vec2,
	size: Vec2,
}

IRect :: struct {
	position: IVec2,
	size: IVec2,
}

irect_from_rect :: proc(rect: ^Rect) -> IRect {
	return IRect{
		{int(rect.position.x), int(rect.position.y)},
		{int(rect.size.x), int(rect.size.y)}}
}
