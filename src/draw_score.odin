package main

draw_score :: proc(score: int, position: IVec2, platform: ^Platform) {
	first_num_text: IRect = {{176, 110}, {5, 9}}

	leading_zeros: bool = true
	for i: int = 5; i > -1; i -= 1 {
		power10: int = 10
		for j in 0..<i {
			power10 *= 10
		}
		digit: int = (score % power10) / (power10 / 10)

		if leading_zeros == true {
			if digit == 0 && i != 0 {
				continue
			} else {
				leading_zeros = false
			}
		}

		num_text: IRect = first_num_text
		num_text.position.x += digit * 5
		buffer_sprite(platform, num_text, IVec2{position.x + 6 * 6 - i * 6, position.y}, IVec2{0, 0}, false)
	}
}
