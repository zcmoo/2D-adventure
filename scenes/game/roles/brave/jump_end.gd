#JumpState
extends State

var velocity = Vector2.ZERO  # 水平和垂直速度

func enter(params = {}):
	velocity.x = 0
	player.changeAnim("jump_end",func finish():
		if state_machine.current_state == self:
			state_machine.change_state("Idle")
	)

func update(delta):
	# 检测跳跃
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state("Run")
	
	state_machine.atkInputEvent()
	
	player.velocity = velocity
