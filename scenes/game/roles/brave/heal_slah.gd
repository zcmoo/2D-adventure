extends State

enum HealState { HEAL_START, HEALING, HEAL_END }
var current_state: HealState = HealState.HEAL_START

var current_tick = 0.0
var MAX_TICK = 5.0

func preMethod():
	var talent = TalentUtils.getTalent('storm_06')
	if talent && PlayerData.useMp(talent):
		return true
	return false

func enter(param = {}):
	player.velocity.x = 0
	current_tick = 0.0
	player.setAnimOffset(Vector2(15,-30))
	
	player.changeAnim("heal_slash_start",func finish():
		if state_machine.current_state == self:
			current_state = HealState.HEALING
			player.changeAnim('heal_slash_ing')
	)

func frame_changed():
	if player.anim_player.animation == 'heal_slash_end' && player.anim_player.frame == 8:
		var enemies = player.checkHit('heal_slash')
		if enemies.size() > 0:
			Game.scale_frame(0.1,0.1)
			for enemy in enemies:
				EffectUtils.addSwordEffect(enemy.global_position)
				enemy.take_damage(get_tick_damage())
				Game.knockback(player,enemy,210,-120)
				player.playAudios("atk_2_hit")

func update(delta):
	match current_state:
		HealState.HEAL_START:
			state_machine.atkInputEvent()

		HealState.HEALING:
			current_tick += delta
			if current_tick >= MAX_TICK:
				exit()
				return
			
			var current_direction = 0
			if Input.is_action_just_pressed("move_left"):
				current_direction = -1
			elif Input.is_action_just_pressed("move_right"):
				current_direction = 1
			
			if current_direction != 0:
				player.flip_h(current_direction)
			
			if not Input.is_action_pressed("heal_slash"):
				exit()  # 松开按键退出格挡
		HealState.HEAL_END:
			#state_machine.atkInputEvent()
			pass

func get_tick_damage():
	var talent = TalentUtils.getTalent('storm_06')
	var attr = talent.effects[0] as Attribute
	var atk = PlayerData.getDamage() * (1 + (attr.value * talent.current_level / 100.0))
	var value = roundi(atk * (1 + (current_tick * 5.0 / 100.0)))
	return value

func exit():
	if current_state != HealState.HEALING:
		return  # 防止重复调用
	player.playAudios("heal_slash")
	current_state = HealState.HEAL_END
	player.setAnimOffset(Vector2(15,-35))
	player.anim_player.frame_changed.connect(self.frame_changed)
	player.changeAnim("heal_slash_end",func finish():
		player.anim_player.frame_changed.disconnect(self.frame_changed)
		if state_machine.current_state == self:
			state_machine.change_state("Idle")
			player.setAnimOffset(Vector2(0,0))
	)
