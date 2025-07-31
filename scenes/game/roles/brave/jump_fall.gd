#JumpState
extends State

var velocity = Vector2.ZERO  # 水平和垂直速度
var MAX_HEIGHT = -300 # 跳跃最高高度

func enter(params = {}):
	player.changeAnim("fall_start",func finish():
		if state_machine.current_state == self:
			player.changeAnim("fall_ing")
	)

func update(delta):
	velocity = player.velocity

	var new_direction = 0
	if Input.is_action_pressed("move_left"):
		new_direction = -1
	elif Input.is_action_pressed("move_right"):
		new_direction = 1

	if new_direction != 0:
		velocity.x = lerp(velocity.x,new_direction  * player.speed,0.5)
		player.flip_h(new_direction)

	if player.is_on_floor():
		if new_direction == 0:
			state_machine.change_state("JumpEnd")
		else:
			state_machine.change_state("Run")
	
	#if Input.is_action_pressed("atk"):
	#	state_machine.change_state("AtkAir",{'state':name})
	
	player.velocity = velocity
