package main
import "core:strings"

Text :: struct {
	position: IVec2,
	string: string,
	font_index: int,
	wave_amplitude: f32,
	wave_t: f32,
}

buffer_text :: proc(platform: ^Platform, position: IVec2, string: string, font_index: int) {
	buffer_text_ext(platform, position, string, font_index, 0, 0)
} 

buffer_text_ext :: proc(platform: ^Platform, position: IVec2, string: string, font_index: int, amp: f32, t: f32) {
	text: Text = {position, string, font_index, amp, t}
	platform.texts[platform.texts_len] = text
	platform.texts[platform.texts_len].string = strings.to_upper(text.string)
	platform.texts_len += 1
}
