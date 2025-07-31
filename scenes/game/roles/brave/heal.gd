extends State

enum HealState { HEAL_START, HEALING, HEAL_END }
var current_state: HealState = HealState.HEAL_START

var current_tick = 0.0
var MAX_TICK = 5.0

func preMethod():
	var talent = TalentUtils.getTalent('buff_04')
	if talent && PlayerData.useMp(talent):
		return true
	return false

func enter(param = {}):
	player.velocity.x = 0
	current_tick = 0
	player.setAnimOffset(Vector2(0,-3))
	
	player.changeAnim("heal_start",func finish():
		if state_machine.current_state == self:
			current_state = HealState.HEALING
			player.changeAnim('heal_ing')
	)

func get_tick_damage():
	var talent = TalentUtils.getTalent('buff_04')
	var attr = talent.effects[0] as Attribute
	var tanlet_valye = attr.value * talent.current_level
	var value = roundi(current_tick * tanlet_valye)
	if value < tanlet_valye:
		return tanlet_valye
	return value

func update(delta):
	match current_state:
		HealState.HEAL_START:
			if Input.is_action_just_pressed("atk"):
				state_machine.change_state("Atk")

		HealState.HEALING:
			current_tick += delta
			if current_tick >= MAX_TICK:
				exit()
				return
			
			if not Input.is_action_pressed("heal"):
				exit()  # 松开按键退出格挡
		HealState.HEAL_END:
			if state_machine.current_state != self:
				state_machine.atkInputEvent()


func exit():
	if current_state != HealState.HEALING:
		return  # 防止重复调用
	current_state = HealState.HEAL_END
	player.changeAnim("heal_end",func finish():
		if state_machine.current_state == self:
			PlayerData.atk_buff_temp = get_tick_damage()
			state_machine.change_state("Idle")
			player.setAnimOffset(Vector2(0,0))
	)
