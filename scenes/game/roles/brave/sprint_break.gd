#RunBreakState
extends State

func enter(params = {}):
	player.setAnimOffset(Vector2(0,-11))
	player.changeAnim("sprint_break",func anim_finish():
		if state_machine.current_state == self:
			state_machine.change_state("Idle"))

func update(delta):
	# 检测输入切换到移动状态
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state("Run")
		return

	# 检测跳跃
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")
		return
	
	if player.velocity.is_equal_approx(Vector2.ZERO) == false:
		player.velocity = player.velocity.lerp(Vector2.ZERO,0.15)
	
	if Input.is_action_just_pressed("atk"):
		state_machine.change_state("Atk",{'state':name})

	if Input.is_action_pressed("block"):
		state_machine.change_state("Block")

func exit():
	player.setAnimOffset(Vector2.ZERO)
