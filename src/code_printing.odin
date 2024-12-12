package main

@(private="file")
CodePrintContext :: struct {
	symbol: IRect,
	position: IVec2,
	codes_drawn: int,
	t: f32,
}

draw_codes :: proc(session: ^Session, platform: ^Platform) {
	ctx: CodePrintContext
	ctx.symbol = {{150, 149}, {8, 8}}
	ctx.position = IVec2{LOGICAL_WIDTH / 2 - 9 * (secret_code_len / 2) + 1, LOGICAL_HEIGHT / 2 - 96}

	// Food is only shown in one specific case, so only appears alone
	if session.food_hint_accomplished {
		draw_code(&ctx, code_builder, platform)
		return
	}

	// This is the most difficult challenge, and so appears alone
	if session.king.character == Character.BUILDER &&
	session.mod_one_life && session.mod_crumbled {
		draw_code(&ctx, code_1bit, platform)
		return
	}

	if session.mod_speed_state == ModSpeedState.FAST {
		switch session.king.character {
		case Character.KING:
			draw_code(&ctx, code_king1, platform)
		case Character.CHEF:
			draw_code(&ctx, code_chef1, platform)
		case Character.BUILDER:
			draw_code(&ctx, code_builder1, platform)
		}
	}

	if session.mod_speed_state == ModSpeedState.SLOW {
		switch session.king.character {
		case Character.KING:
			draw_code(&ctx, code_king2, platform)
		case Character.CHEF:
			draw_code(&ctx, code_chef2, platform)
		case Character.BUILDER:
			draw_code(&ctx, code_builder2, platform)
		}
	}

	if session.mod_low_grav {
		switch session.king.character {
		case Character.KING:
			draw_code(&ctx, code_king3, platform)
		case Character.CHEF:
			draw_code(&ctx, code_chef3, platform)
		case Character.BUILDER:
			draw_code(&ctx, code_builder3, platform)
		}
	}

	if session.mod_one_life {
		draw_code(&ctx, code_low_grav, platform)
		draw_code(&ctx, code_fast, platform)
		draw_code(&ctx, code_slow, platform)
	}

	if session.king.character == Character.BUILDER {
		draw_code(&ctx, code_king_fin, platform)
	}

	// Must be last before character specific
	if session.mod_crumbled {
		ctx.position -= 3
		ctx.symbol.position.x += 16
		ctx.symbol.size.x = 11
		ctx.symbol.size.y = 9

		draw_code(&ctx, code_food, platform)
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
draw_code :: proc(ctx: ^CodePrintContext, code: [secret_code_len]int, platform: ^Platform) {
	for i in 0..<secret_code_len {
		if ctx.t < f32(-4 - i - ctx.codes_drawn) {
			spr: IRect = ctx.symbol
			if code[i] == 1 {
				spr.position.x += spr.size.x
			}
			buffer_sprite(platform, spr, IVec2{ctx.position.x + (spr.size.x + 1) * i, ctx.position.y}, IVec2{0, 0}, false)
		}
	}

	ctx.position.y -= 11
	ctx.codes_drawn += 1
	ctx.t += 1
}
