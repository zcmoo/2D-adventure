extends EnemyState

func enter(param = {}):
	player.anim_player.offset.y = -9
	player.changeAnim("ranged_atk",func finish():
		state_machine.change_state("Idle"))

func exit():
	player.anim_player.offset.y = 0
