package main

CodeCharacter :: enum {
	NONE,
	KING,
	CHEF,
	BUILDER,
}

@(private="file")
CodePrintContext :: struct {
	symbol: IRect,
	position: IVec2,
	codes_drawn: int,
	t: f32,
	character: CodeCharacter,
}

draw_codes :: proc(session: ^Session, platform: ^Platform) {
	ctx: CodePrintContext
	ctx.symbol = {{310, 160}, {8, 8}}
	ctx.position = IVec2{LOGICAL_WIDTH / 2 - 40, LOGICAL_HEIGHT / 2 - 96}
	ctx.t = session.time_to_next_state
	ctx.character = CodeCharacter.NONE

	// Food is only shown in one specific case, so only appears alone
	if session.food_hint_accomplished {
		draw_code(&ctx, code_builder, platform)
		return
	}

	// This is the most difficult challenge, and so appears alone
	if session.king.character == Character.BUILDER &&
	session.mod_one_life && session.mod_crumbled {
		draw_code(&ctx, code_king_sha, platform)
		return
	}

	if session.mod_speed_state == ModSpeedState.FAST {
		switch session.king.character {
		case Character.KING:
			draw_character_code(&ctx, code_king1, CodeCharacter.KING, platform)
		case Character.CHEF:
			draw_character_code(&ctx, code_chef1, CodeCharacter.CHEF, platform)
		case Character.BUILDER:
			draw_character_code(&ctx, code_builder1, CodeCharacter.BUILDER, platform)
		}
	}

	if session.mod_speed_state == ModSpeedState.SLOW {
		switch session.king.character {
		case Character.KING:
			draw_character_code(&ctx, code_king2, CodeCharacter.KING, platform)
		case Character.CHEF:
			draw_character_code(&ctx, code_chef2, CodeCharacter.CHEF, platform)
		case Character.BUILDER:
			draw_character_code(&ctx, code_builder2, CodeCharacter.BUILDER, platform)
		}
	}

	if session.mod_one_life {
		draw_code(&ctx, code_random, platform)
		draw_code(&ctx, code_fast, platform)
		draw_code(&ctx, code_slow, platform)
	}

	if session.king.character == Character.BUILDER {
		draw_code(&ctx, code_king_fin, platform)
	}

	// Must be last before character specific
	if session.mod_crumbled {
		ctx.position.x = LOGICAL_WIDTH / 2 - 32
		ctx.symbol = {{320, 112}, {16, 16}}
		draw_food_code(&ctx, code_food, platform)
	}

	if ctx.codes_drawn > 0 {
		return
	}

	// Draw character completion codes only if no other codes have been drawn
	if session.king.character == Character.KING {
		draw_code(&ctx, code_chef, platform)
	} else if session.king.character == Character.CHEF {
		draw_code(&ctx, code_one_life, platform)
		draw_code(&ctx, code_crumbled, platform)
	}
}

@(private="file")
draw_code_ex :: proc(ctx: ^CodePrintContext, code: [secret_code_len]int, character: CodeCharacter, food_hint: bool, platform: ^Platform) {
	delay: f32 = 0
	draw_pos: IVec2 = ctx.position
	if character != CodeCharacter.NONE {
		draw_pos.x += 5
		delay = 1

		if ctx.t < f32(-4 - ctx.codes_drawn) {
			spr: IRect = {{262, 238}, {9, 9}}
			if character == CodeCharacter.CHEF {
				spr.position.x += 9
			} else if character == CodeCharacter.BUILDER {
				spr.position.x += 18
			}
			buffer_sprite(platform, spr, IVec2{ctx.position.x - 5, ctx.position.y - 1}, IVec2{0, 0}, false)
		}
	}

	iter_len: int = secret_code_len
	if food_hint {
		iter_len = 3
	}
	for i in 0..=iter_len {
		if ctx.t > f32(-4 - i - ctx.codes_drawn) - delay {
			break
		}

		spr: IRect = ctx.symbol
		if i == secret_code_len {
			spr.position.x += spr.size.x * 2
		} else {
			spr.position.x += code[i] * spr.size.x
		}
		buffer_sprite(platform, spr, IVec2{draw_pos.x + (spr.size.x + 1) * i, draw_pos.y}, IVec2{0, 0}, false)
	}

	ctx.position.y -= 11
	ctx.codes_drawn += 1
	ctx.t += 1
}

@(private="file")
draw_code :: proc(ctx: ^CodePrintContext, code: [secret_code_len]int, platform: ^Platform) {
	draw_code_ex(ctx, code, CodeCharacter.NONE, false, platform)
}

@(private="file")
draw_food_code :: proc(ctx: ^CodePrintContext, code: [secret_code_len]int, platform: ^Platform) {
	draw_code_ex(ctx, code, CodeCharacter.NONE, true, platform)
}

@(private="file")
draw_character_code :: proc(ctx: ^CodePrintContext, code: [secret_code_len]int, character: CodeCharacter, platform: ^Platform) {
	draw_code_ex(ctx, code, character, false, platform)
}
