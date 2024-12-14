package main
import "core:fmt"
import "core:math/rand"

rand_mod :: proc() -> f32 {
	res: f32 = (rand.float32() * 1.75) + 0.5
	fmt.println(res)
	return res
}
