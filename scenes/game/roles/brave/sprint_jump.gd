#JumpState
extends State

var velocity = Vector2.ZERO  # 水平和垂直速度
var MAX_HEIGHT = -220 # 跳跃最高高度
var is_jump = false

func enter(params = {}):
	is_jump = true
	player.anim_player.frame_changed.connect(self.frame_changed)
	player.setAnimOffset(Vector2(0,3))
	player.changeAnim("sprint_jump",func finish():
		if state_machine.current_state == self:
			state_machine.change_state("Idle")
	)

func frame_changed():
	if player.anim_player.animation == 'sprint_jump' and player.anim_player.frame == 12:
		player.velocity.x *= 0.9
		is_jump = false
		player.velocity.y = 0

func exit():
	player.anim_player.frame_changed.disconnect(self.frame_changed)
	player.setAnimOffset(Vector2(0,0))

func update(delta):
	velocity = player.velocity
	if player.is_on_floor() && is_jump:
		velocity.y = MAX_HEIGHT
	player.velocity = velocity
	
	if player.anim_player.frame >= 12:
		state_machine.atkInputEvent()
