extends State

@onready var timer = $Timer

var current_tick = 0
var max_tick = 30
var can_use = true

func preMethod():
	if can_use == false:
		MessageBox.alert("冷却中")
		return
	var talent = TalentUtils.getTalent('block_05')
	if talent && PlayerData.useMp(talent):
		return true
	return false

func enter(param = {}):
	player.velocity.x = 0
	
	player.setAnimOffset(Vector2(2,-8))
	
	player.changeAnim("shield_buff",func finish():
		if state_machine.current_state == self:
			can_use = false
			timer.start()
			current_tick = 0
			PlayerData.player_def += 15
			state_machine.change_state("Idle")
	)

func exit():
	player.setAnimOffset(Vector2(0,0))

func _on_timer_timeout() -> void:
	current_tick += 1
	
	if current_tick == 25:
		MessageBox.alert("强化护甲失效！")
		PlayerData.player_def -= 15
	elif current_tick == 30:
		can_use = true
