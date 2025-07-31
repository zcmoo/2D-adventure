extends State

func enter(param = {}):
	player.setAnimOffset(Vector2(0,-3))
	player.changeAnim("block_break",func finish():
		pass
	)

func exit():
	player.setAnimOffset(Vector2.ZERO)
