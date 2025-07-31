extends State

enum HealState { HEAL_START, HEALING, HEAL_END }
var current_state: HealState = HealState.HEAL_START

const anim_name = "saint_heal"

var current_tick = 0.0

func preMethod():
	var talent = TalentUtils.getTalent('buff_03')
	if talent && PlayerData.useMp(talent):
		return true
	return false

func enter(param = {}):
	player.velocity.x = 0
	current_tick = 0
	player.setAnimOffset(Vector2(1,-2))
	
	player.changeAnim(anim_name+"_start",func finish():
		if state_machine.current_state == self:
			current_state = HealState.HEALING
			player.changeAnim(anim_name+"_ing")
	)

func get_tick_damage():
	var talent = TalentUtils.getTalent('buff_03')
	var attr = talent.effects[0] as Attribute
	var atk = attr.value * talent.current_level
	return atk

func update(delta):
	match current_state:
		HealState.HEAL_START:
			if Input.is_action_just_pressed("atk"):
				state_machine.change_state("Atk")

		HealState.HEALING:
			current_tick += delta
			if current_tick >= 1:
				PlayerData.health(get_tick_damage())
				current_tick = 0
			
			if not Input.is_action_pressed("saint_heal"):
				exit()  # 松开按键退出格挡
		HealState.HEAL_END:
			if state_machine.current_state != self:
				state_machine.atkInputEvent()

func exit():
	if current_state != HealState.HEALING:
		return  # 防止重复调用
	PlayerData.health(get_tick_damage())
	current_state = HealState.HEAL_END
	player.changeAnim(anim_name+"_end",func finish():
		if state_machine.current_state == self:
			state_machine.change_state("Idle")
			player.setAnimOffset(Vector2(0,0))
	)
