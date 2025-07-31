# IdleState.gd
extends State

func enter(params = {}):
	player.changeAnim("idle")
	player.velocity.x = 0

func update(delta):
	# 检测输入切换到移动状态
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state("Run")

	# 检测跳跃
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")

	state_machine.atkInputEvent()
	
	if Input.is_action_pressed("block"):
		state_machine.change_state("Block")
	
	
