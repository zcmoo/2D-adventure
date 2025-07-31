extends State

@export var trail_interval = 0.02  # 每隔多少秒生成一个残影
enum HealState { HEAL_START, HEALING, HEAL_END }
var current_state: HealState = HealState.HEAL_START

var current_tick = 0.0
var trail_timer = 0
var can_create = false
var MAX_TICK = 5.0

func preMethod():
	var talent = TalentUtils.getTalent('storm_07')
	if talent && PlayerData.useMp(talent):
		return true
	return false

func get_tick_damage():
	var talent = TalentUtils.getTalent('storm_07')
	var attr = talent.effects[0] as Attribute
	var atk = PlayerData.getDamage() * (1 + (attr.value * talent.current_level / 100.0))
	var value = roundi(atk * (1 + (current_tick * 5.0 / 100.0)))
	return value

func enter(param = {}):
	current_tick = 0.0
	player.velocity.x = 0
	player.setAnimOffset(Vector2(0,3))
	player.changeAnim("light_cut_start",func finish():
		if state_machine.current_state == self:
			current_state = HealState.HEALING
			player.changeAnim('light_cut_ing')
	)

func update(delta):
	match current_state:
		HealState.HEAL_START:
			if state_machine.current_state != self:
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
			
			if not Input.is_action_pressed("light_cut"):
				exit()  # 松开按键退出格挡
		HealState.HEAL_END:
			#state_machine.atkInputEvent()
			if can_create:
				trail_timer -= delta
				# 在 Dash 过程中定时生成残影
				if trail_timer <= 0:
					
					EffectUtils.create_trail({
						"texture":player.anim_player.sprite_frames.get_frame_texture(player.anim_player.animation,player.anim_player.frame),
						"global_position":player.global_position,
						"offset":player.anim_player.position,
						"transform":player.body.global_transform.x.x
					})
					trail_timer = trail_interval
			pass

var is_freeze = false
func frame_changed():
	if player.anim_player.animation == 'light_cut_end':
		if player.anim_player.frame < 3:
			can_create = true
			var enemies = player.checkHit('light_cut')
			if enemies.size() > 0:
				if not is_freeze:
					Game.scale_frame(0.1,0.1)
					#Game.time_scale_frame(0.5,0.01)
					is_freeze = true
				for enemy in enemies:
					EffectUtils.addSwordEffect(enemy.global_position)
					enemy.take_damage(get_tick_damage())
					Game.knockback(player,enemy,25)
					player.playAudios('atk_1_hit')
		if player.anim_player.frame == 3:
			player.velocity.x = 0
			can_create = false

func exit():
	if current_state != HealState.HEALING:
		return  # 防止重复调用
	player.playAudios('light_cut')
	player.anim_player.frame_changed.connect(self.frame_changed)
	current_state = HealState.HEAL_END
	player.velocity.x = player.speed * 6 * player.get_facing_direction().x
	is_freeze = false
	can_create = false
	player.changeAnim("light_cut_end",func finish():
		player.anim_player.frame_changed.disconnect(self.frame_changed)
		state_machine.change_state("Idle")
		player.setAnimOffset(Vector2(0,0))
	)
