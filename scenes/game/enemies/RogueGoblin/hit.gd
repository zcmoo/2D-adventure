extends EnemyState

func enter(params = {}):
	player.anim_player.offset.y = -1
	player.changeAnim("hit",func finish():
		state_machine.change_state("Idle")
	)
	player.velocity.x = 0
	player.anim_player.material.set("shader_parameter/active",true)
	await get_tree().create_timer(0.1).timeout
	player.anim_player.material.set("shader_parameter/active",false)
	

func exit():
	player.anim_player.offset.y = 0
