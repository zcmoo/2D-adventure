#JumpState
extends State

var velocity = Vector2.ZERO  # 水平和垂直速度
var MAX_HEIGHT = -220 # 跳跃最高高度

func enter(params = {}):
	player.changeAnim("jump_start",func finish():
		if state_machine.current_state == self:
			player.changeAnim("jump_ing")
	)

func update(delta):
	velocity = player.velocity
	if player.is_on_floor():
		velocity.y = MAX_HEIGHT
	
	if velocity.y > 0:
		state_machine.change_state("JumpFall")
		return
	
	var new_direction = 0
	if Input.is_action_pressed("move_left"):
		new_direction = -1
	elif Input.is_action_pressed("move_right"):
		new_direction = 1
		
	if new_direction != 0:
		velocity.x = lerp(velocity.x,new_direction  * player.speed,0.5)
		player.flip_h(new_direction)
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("atk"):
		state_machine.change_state("AtkAir",{'state':name})
	
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash")
		return
	player.velocity = velocity
