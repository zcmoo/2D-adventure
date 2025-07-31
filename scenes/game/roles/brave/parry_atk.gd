extends State

func enter(param = {}):
	player.anim_player.flip_h = true
	player.setAnimOffset(Vector2(11,-18))
	player.changeAnim("parry_atk",func finish():
		state_machine.change_state("Idle"))
	
func exit():
	player.anim_player.flip_h = false
	player.setAnimOffset(Vector2(0,0))
