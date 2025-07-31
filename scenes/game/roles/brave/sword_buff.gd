extends State

@onready var timer = $Timer

var current_tick = 0
var max_tick = 30
var can_use = true

var temp_atk = 0

func preMethod():
	if can_use == false:
		MessageBox.alert("冷却中")
		return
	var talent = TalentUtils.getTalent('buff_02')
	if talent && PlayerData.useMp(talent):
		return true
	return false


func enter(param = {}):
	player.velocity.x = 0
	player.setAnimOffset(Vector2(-6,-7))
	player.changeAnim("sword_buff",func finish():
		if state_machine.current_state == self:
			can_use = false
			timer.start()
			current_tick = 0
			temp_atk = get_tick_damage()
			PlayerData.player_atk += temp_atk
			state_machine.change_state("Idle")
	)

func get_tick_damage():
	var talent = TalentUtils.getTalent('buff_02')
	var attr = talent.effects[0] as Attribute
	var atk = attr.value * talent.current_level
	return atk

func exit():
	player.setAnimOffset(Vector2(0,0))


func _on_timer_timeout() -> void:
	current_tick += 1
	
	if current_tick == 25:
		MessageBox.alert("附魔之剑失效！")
		PlayerData.player_atk -= temp_atk
	elif current_tick == 30:
		can_use = true
