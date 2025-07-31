extends State

var target_direction

func enter(params = {}):
	print("enter Trick")
	target_direction = params["direction"]
	player.changeAnim("run_turn_left",func finish():
		player.flip_h(target_direction)
		state_machine.change_state("Run")
	)
