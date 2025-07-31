extends State

var current_direction = 0

func enter(param = {}):
	player.playAudios('hit')
	player.setAnimOffset(Vector2(0,-7))
	player.anim_player.stop()
	player.changeAnim("hit",func finish():
		state_machine.change_state("Idle"))
	
	player.velocity.x = 0
	player.anim_player.material.set("shader_parameter/active",true)
	await get_tree().create_timer(0.1).timeout
	player.anim_player.material.set("shader_parameter/active",false)

func update(delta):
	
	#if Input.is_action_just_pressed("move_left"):
	#	current_direction = -1
	#elif Input.is_action_just_pressed("move_right"):
	#	current_direction = 1
	
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash")
		return
	

func exit():
	#if current_direction != 0:
	#	player.flip_h(current_direction)
	player.setAnimOffset(Vector2.ZERO)
