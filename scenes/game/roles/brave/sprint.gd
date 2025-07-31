#SprintState
extends State

var velocity = Vector2.ZERO  # 水平和垂直速度

func enter(params = {}):
	player.speed += 50
	player.setAnimOffset(Vector2(0,-11))
	player.changeAnim("sprint_start",func anim_finish():
		if state_machine.current_state == self:
			player.changeAnim("sprint_ing")
		)

func update(delta):
	velocity = player.velocity
	var new_direction = 0 # 检测输入方向

	if Input.is_action_pressed("move_left"):
		new_direction = -1
	elif Input.is_action_pressed("move_right"):
		new_direction = 1

	if new_direction != 0:
		velocity.x = lerp(velocity.x,new_direction  * player.speed,0.5)
		player.flip_h(new_direction)
	elif player.is_on_floor():
		state_machine.change_state("SprintBreak")

	# 跳跃
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")
		return

	if Input.is_action_just_pressed("atk"):
		state_machine.change_state("Atk",{'state':name})
		return
	
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash")
		return
	
	if Input.is_action_pressed("block"):
		state_machine.change_state("Block")
		return
	# 应用速度
	player.velocity = velocity

func exit():
	player.speed -= 50
	player.setAnimOffset(Vector2.ZERO)
