extends State

var velocity = Vector2.ZERO  # 水平和垂直速度
var combo_count = 0          # 当前连击段数
var combo_window = 0.5       # 连击的输入时间窗口（秒）
var timer = 0.0              # 记录输入窗口时间
var is_next_combo_triggered = false  # 标志是否触发下一段连击
var current_direction = 0
var max_combo_count = 2      #最大连击

func _init() -> void:
	TalentUtils.on_talent_upgrade.connect(self.on_talent_upgrade)

# 天赋升级事件
func on_talent_upgrade(_talent:Talent):
	if _talent.id == 'storm_02': # 突刺技能
		max_combo_count = 3 

func enter(params = {}):
	combo_count = params.get("combo", 1)  # 默认从第一段开始
	timer = 0.0
	is_next_combo_triggered = false
	play_combo_animation(combo_count)
	player.anim_player.frame_changed.connect(self.frame_changed)

func update(delta):
	# 冲刺
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash",{"direction":Vector2(current_direction,0)})
		return
	
	# 检测攻击键输入
	if Input.is_action_just_pressed("atk") and not is_next_combo_triggered:
		if combo_count < max_combo_count:  # 限制最多三段连击
			is_next_combo_triggered = true
	
	# 如果动画结束但未触发连击，返回空闲
	if timer >= combo_window and not is_next_combo_triggered:
		state_machine.change_state("Idle")

	if Input.is_action_just_pressed("move_left"):
		current_direction = -1
	elif Input.is_action_just_pressed("move_right"):
		current_direction = 1

func exit():
	player.velocity.x = 0
	current_direction = 0
	player.setAnimOffset(Vector2.ZERO)  # 离开状态时重置偏移
	player.anim_player.frame_changed.disconnect(self.frame_changed)

# 播放对应段数的攻击动画
func play_combo_animation(combo):
	var anim_name = "atk_" + str(combo)
	player.changeAnim(anim_name, func finish():
		handle_attack_end()  # 动画完成后检查是否进入下一连击
	)
	player.setAnimOffset(Vector2(23, -3))
	player.playAudios(anim_name)
	player.velocity.x = player.get_facing_direction().x * player.speed

# 处理攻击结束逻辑
func handle_attack_end():
	if current_direction != 0:
		player.flip_h(current_direction)
	if is_next_combo_triggered:
		# 如果有连击输入，切换到下一段攻击
		combo_count += 1
		state_machine.change_state("Atk", {"combo": combo_count})
	else:
		# 如果没有输入，回到空闲状态
		state_machine.change_state("Idle")

# 关键帧获取
func frame_changed():
	if player.anim_player.animation == 'atk_1' && player.anim_player.frame == 5:
		damageEnemies()
	if player.anim_player.animation == 'atk_2' && player.anim_player.frame == 4:
		damageEnemies()
	if player.anim_player.animation == 'atk_3' && player.anim_player.frame == 6:
		damageEnemies()
	player.velocity.x = 0

func damageEnemies():
	var enemies = player.checkHit(player.anim_player.animation)
	if enemies.size() > 0:
		playAudios(player.anim_player.animation,true,combo_count)
		PlayerData.useAnger(5)
	for enemy in enemies:
		EffectUtils.addSwordEffect(enemy.global_position)
		enemy.take_damage(PlayerData.getDamage())
		Game.knockback(player,enemy,50)

func playAudios(anim_name,is_hit,combo_count):
	if is_hit:
		anim_name = anim_name + "_hit"
		Game.camera.start_shake(combo_count*1.2)
		if combo_count < 3:
			#Game.freeze_frame(0.04)
			Game.scale_frame(0.07,0.25)
		else:
			#Game.scale_frame(0.1,0.3)
			Game.time_scale_frame(0.1,0.35)
		player.playAudios(anim_name)
