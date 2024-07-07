package main

is_colliding :: proc(col1: ^Rect, pos1: ^Vec2, col2: ^Rect, pos2: ^Vec2) -> bool {
	col1_offset: Rect = offset_collider(col1, pos1)
	col2_offset: Rect = offset_collider(col2, pos2)
	return aabb(&col1_offset, &col2_offset)
}

@(private="file")
aabb :: proc(r1: ^Rect, r2: ^Rect) -> bool {
	return r1.position.x < r2.position.x + r2.size.x &&
		   r1.position.x + r1.size.x > r2.position.x &&
		   r1.position.y < r2.position.y + r2.size.y &&
		   r1.position.y + r1.size.y > r2.position.y
}

@(private="file")
offset_collider :: proc(collider: ^Rect, position: ^Vec2) -> Rect {
	return {
		{position.x + collider.position.x,
		position.y + collider.position.y},
		{collider.size.x,
		collider.size.y}}
}
