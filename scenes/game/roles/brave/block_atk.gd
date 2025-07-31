extends State

var velocity = Vector2.ZERO  # 水平和垂直速度
var combo_count = 1          # 当前连击段数
var combo_window = 1.5       # 连击的输入时间窗口（秒）
var timer = 0.0              # 记录输入窗口时间
var is_next_combo_triggered = false  # 标志是否触发下一段连击
var current_direction = 0
var max_combo_count = 2      #最大连击

# 前置条件 攻守兼备
func preMethod():
	var talent = TalentUtils.getTalent('block_04')
	if talent && PlayerData.useMp(talent):
		return true
	state_machine.change_state("Block",{"block_ing":true})
	return false

func enter(params = {}):
	player.setAnimOffset(Vector2(0,-10))
	timer = 0.0
	is_next_combo_triggered = false
	play_combo_animation(combo_count)
	player.anim_player.frame_changed.connect(self.frame_changed)

func update(delta):
	# 检测攻击键输入
	if Input.is_action_just_pressed("atk") and not is_next_combo_triggered:
		if combo_count < max_combo_count:  # 限制最多三段连击
			is_next_combo_triggered = true
		else:
			combo_count = 1
	
	# 如果动画结束但未触发连击，返回空闲
	if timer >= combo_window and not is_next_combo_triggered:
		state_machine.change_state("Idle")

	if Input.is_action_just_pressed("move_left"):
		current_direction = -1
	elif Input.is_action_just_pressed("move_right"):
		current_direction = 1

func exit():
	current_direction = 0
	player.setAnimOffset(Vector2.ZERO)  # 离开状态时重置偏移
	player.anim_player.frame_changed.disconnect(self.frame_changed)

# 播放对应段数的攻击动画
func play_combo_animation(combo):
	var anim_name = "guarded_atk_" + str(combo)
	player.changeAnim(anim_name, func finish():
		handle_attack_end()  # 动画完成后检查是否进入下一连击
	)
	player.playAudios('atk_3')

# 处理攻击结束逻辑
func handle_attack_end():
	if current_direction != 0:
		player.flip_h(current_direction)
	if is_next_combo_triggered:
		# 如果有连击输入，切换到下一段攻击
		combo_count += 1
		state_machine.change_state("BlockAtk")
	else:
		# 如果没有输入，回到空闲状态
		state_machine.change_state("Block",{"block_ing":true})

# 关键帧获取
func frame_changed():
	if player.anim_player.animation == 'guarded_atk_1' && player.anim_player.frame == 1:
		damageEnemies()
	if player.anim_player.animation == 'guarded_atk_2' && player.anim_player.frame == 1:
		damageEnemies()
	if player.anim_player.animation == 'guarded_atk_3' && player.anim_player.frame == 1:
		damageEnemies()
	player.velocity.x = 0


func damageEnemies():
	var enemies = player.checkHit('guarded_atk')
	if enemies.size() > 0:
		playAudios('atk_3',true,combo_count)
		PlayerData.useAnger(5)
	for enemy in enemies:
		EffectUtils.addSwordEffect(enemy.global_position)
		enemy.take_damage(PlayerData.getDamage())
		Game.knockback(player,enemy,20)

func playAudios(anim_name,is_hit,combo_count):
	if is_hit:
		anim_name = anim_name + "_hit"
		Game.camera.start_shake(combo_count*1.2)
		if combo_count < 3:
			Game.scale_frame(0.08,0.5)
		else:
			Game.scale_frame(0.1,0.3)
		player.playAudios(anim_name)
