package main

Assets :: struct {
	sequences: Sequences,
    config: Config,
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

    builder: Sequence,
    builder_idle: Sequence,
    builder_run: Sequence,
    builder_jump: Sequence,
    builder_float: Sequence,
    builder_post_float: Sequence,
}

load_assets :: proc(assets: ^Assets, platform: ^Platform) {
	using assets

	{
		using sequences
		tile_island_src = {{160, 0}, {16, 16}}
		tile_center_src = {{224, 0}, {16, 16}}
		tile_left_src = {{288, 0}, {16, 16}}
		tile_right_src = {{352, 0}, {16, 16}}

		king_idle =       {{{112, 0}, {16, 21}}, 2, {8, 21}, 0.15}
		king_run =        {{{0, 0}, {16, 21}}, 4, {8, 21}, 0.15}
		king_jump =       {{{96, 0}, {16, 21}}, 1, {8, 21}, 0.1}
		king_float =      {{{64, 0}, {16, 21}}, 1, {8, 21}, 0.1}
		king_post_float = {{{80, 0}, {16, 21}}, 1, {8, 21}, 0.1}

		guard_idle = {{{64, 231}, {16, 21}}, 2, {8, 21}, 0.15}
		guard_run =  {{{0, 231}, {16, 21}}, 4, {8, 21}, 0.15}
		guard_jump = {{{112, 231}, {16, 21}}, 1, {8, 21}, 0.1}
		guard_end =  {{{32, 231}, {16, 21}}, 2, {8, 21}, 0.1}

		chef_idle =       {{{112, 105}, {16, 21}}, 2, {8, 21}, 0.15}
		chef_run =        {{{0,   105}, {16, 21}}, 4, {8, 21}, 0.15}
		chef_jump =       {{{32,  105}, {16, 21}}, 1, {8, 21}, 0.1}
		chef_float =      {{{64,  105}, {16, 21}}, 3, {8, 21}, 0.1}
		chef_post_float = {{{80,  105}, {16, 21}}, 1, {8, 21}, 0.1}

		builder_idle =       {{{112, 168}, {16, 21}}, 2, {8, 21}, 0.15}
		builder_run =        {{{0, 168}, {16, 21}}, 4, {8, 21}, 0.15}
		builder_jump =       {{{64, 168}, {16, 21}}, 1, {8, 21}, 0.1}
		builder_float =      {{{0, 168}, {16, 21}}, 1, {8, 21}, 0.1}
		builder_post_float = {{{0, 168}, {16, 21}}, 1, {8, 21}, 0.1}
	}

    init_config(&config)
}
