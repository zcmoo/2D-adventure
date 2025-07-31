extends State

func enter(param = {}):
	player.changeAnim("death")
	player.setAnimOffset(Vector2(0,3))

func exit():
	player.setAnimOffset(Vector2(0,0))
