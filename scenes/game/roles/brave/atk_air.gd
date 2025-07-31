extends State

func enter(param = {}):
	player.changeAnim("atk_air",atkFinish)
	player.playAudios('atk_3')

func update(d):
	player.velocity.x *= 0.9
	player.velocity.y = 0

func atkFinish():
	if player.is_on_floor():
		state_machine.change_state("Idle")
	else:
		state_machine.change_state("JumpFall")
