package main
import "core:math/rand"

FIREWORK_PARTICLE_COUNT :: 32
TOTAL_PARTICLE_COUNT :: FIREWORK_PARTICLE_COUNT * 8
PARTICLE_COLOR_COUNT :: 4
PARTICLE_MAX_VELOCITY :: 40

ParticleSystem :: struct {
	particles: [TOTAL_PARTICLE_COUNT]Particle,
	next_particle: int,
	time_to_firework: f32,
}

Particle :: struct {
	position: Vec2,
	velocity: Vec2,
	color: int, // just offsets src position
}

update_fireworks :: proc(particle_system: ^ParticleSystem, dt: f32) {
	using particle_system

	time_to_firework -= dt
	if time_to_firework < 0 {
		reset_firework_timer(&time_to_firework)
		firework_position: Vec2 = {rand.float32() * LOGICAL_WIDTH, rand.float32() * LOGICAL_HEIGHT}

		for i := 0; i < FIREWORK_PARTICLE_COUNT; i += 1 {
			next_particle += 1
			if next_particle >= TOTAL_PARTICLE_COUNT {
				next_particle = 0
			}

			particles[next_particle].position = firework_position
			particles[next_particle].velocity = {
				rand.float32() * PARTICLE_MAX_VELOCITY * 2 - PARTICLE_MAX_VELOCITY,
				rand.float32() * PARTICLE_MAX_VELOCITY * 2 - PARTICLE_MAX_VELOCITY}
		}
	}

	for &particle in particles {
		particle.velocity.y += dt * 90
		particle.position += particle.velocity * dt
	}
}

draw_fireworks :: proc(particle_system: ^ParticleSystem, platform: ^Platform) {
	using particle_system

	for &particle in particles {
		if particle.position.y > LOGICAL_HEIGHT * 2 {
			continue
		}

		src_pos: IVec2 = {331, 20}
		src_pos.x += particle.color * 2
		buffer_sprite(platform, IRect{src_pos, {2, 2}}, ivec2_from_vec2(particle.position), IVec2{0, 0}, false)
	}
}

init_fireworks :: proc(particle_system: ^ParticleSystem) {
	using particle_system

	reset_firework_timer(&time_to_firework)

	for &particle in particles {
		particle.color = rand.int_max(PARTICLE_COLOR_COUNT)
		particle.position = LOGICAL_HEIGHT * 2
	}
}

reset_firework_timer :: proc(time_to_firework: ^f32) {
	time_to_firework^ = rand.float32() * 2 * 0.5
}
