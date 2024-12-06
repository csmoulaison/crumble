package main

Assets :: struct {
	sequences: Sequences,
	fonts: UIFonts,
    config: Config,
}

UIFonts :: struct {
	white: int,
	red: int,
}

Sequences :: struct {
	// Because tiles don't need animators
	tile_island_src: IRect,
	tile_center_src: IRect,
	tile_left_src: IRect,
	tile_right_src: IRect,

	bubbling_pot: Sequence,
	platter: Sequence,

	king_idle: Sequence,
	king_run: Sequence,
	king_jump: Sequence,
	king_float: Sequence,
	king_post_float: Sequence,

	guard_idle: Sequence,
	guard_run: Sequence,
	guard_jump: Sequence,
	guard_end: Sequence,

	window: Sequence,
	
	emote_alarm: Sequence,
	emote_confused: Sequence,

	foods: [4]Sequence,

    chef: Sequence,
    chef_idle: Sequence,
    chef_run: Sequence,
    chef_jump: Sequence,
    chef_float: Sequence,
    chef_post_float: Sequence,
}

load_assets :: proc(assets: ^Assets, platform: ^Platform) {
	using assets

	{
		using sequences
		tile_island_src = {{0, 0}, {16, 16}}
		tile_center_src = {{64, 0}, {16, 16}}
		tile_left_src = {{128, 0}, {16, 16}}
		tile_right_src = {{192, 0}, {16, 16}}

		king_idle =       {{{112, 16}, {16, 21}}, 2, {8, 21}, 0.15}
		king_run =        {{{0, 16}, {16, 21}}, 4, {8, 21}, 0.15}
		king_jump =       {{{96, 16}, {16, 21}}, 1, {8, 21}, 0.1}
		king_float =      {{{64, 16}, {16, 21}}, 1, {8, 21}, 0.1}
		king_post_float = {{{80, 16}, {16, 21}}, 1, {8, 21}, 0.1}

		guard_idle = {{{224, 16}, {16, 21}}, 2, {8, 21}, 0.15}
		guard_run =  {{{160, 16}, {16, 21}}, 4, {8, 21}, 0.15}
		guard_jump = {{{270, 16}, {16, 21}}, 1, {8, 21}, 0.1}
		guard_end =  {{{192, 16}, {16, 21}}, 2, {8, 21}, 0.1}

		chef_idle =       {{{112, 37}, {16, 21}}, 2, {8, 21}, 0.15}
		chef_run =        {{{0,   37}, {16, 21}}, 4, {8, 21}, 0.15}
		chef_jump =       {{{32,  37}, {16, 21}}, 1, {8, 21}, 0.1}
		chef_float =      {{{64,  37}, {16, 21}}, 3, {8, 21}, 0.1}
		chef_post_float = {{{80,  37}, {16, 21}}, 1, {8, 21}, 0.1}
	}

    {
        using fonts
        white = new_font_handle(platform, "textures/font_white.bmp")
        red = new_font_handle(platform, "textures/font_red.bmp")
    }

    init_config(&config)
}
