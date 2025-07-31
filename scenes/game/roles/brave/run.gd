extends State

var velocity = Vector2.ZERO  # 水平和垂直速度
var run_time = 0.0           # 记录持续奔跑的时间
@export var sprint_threshold = 0.5  # 超过 1 秒切换为急速奔跑
@export var sprint_speed_multiplier = 1.5  # 急速奔跑速度倍率
var is_sprint = false # 是否是疾跑模式
var has_sprint = false

func enter(params = {}):
	has_sprint = is_instance_valid(TalentUtils.getTalent('storm_04'))
	run_time = 0.0  # 初始化计时器
	player.changeAnim("run_start", func anim_finish():
		if state_machine.current_state == self:
			player.changeAnim("run_ing")
		)
	
func update(delta):
	velocity = player.velocity
	var new_direction = 0  # 检测输入方向

	# 检测左右移动
	if Input.is_action_pressed("move_left"):
		new_direction = -1
	elif Input.is_action_pressed("move_right"):
		new_direction = 1

	# 如果有方向输入，更新速度
	if new_direction != 0:
		# 检查是否进入急速跑步状态
		run_time += delta
		if has_sprint && run_time > sprint_threshold:
			is_sprint = true
			player.setAnimOffset(Vector2(0,5))
			player.changeAnim("sprint_ing")  # 切换到急速跑步动画
			velocity.x = lerp(velocity.x, new_direction * player.speed * sprint_speed_multiplier, 0.5)
		else:
			velocity.x = lerp(velocity.x, new_direction * player.speed, 0.5)
		player.flip_h(new_direction)  # 翻转角色方向
	else:
		# 无输入时停止奔跑，重置计时器
		run_time = 0.0
		if player.is_on_floor():
			state_machine.change_state("RunBreak",{"is_sprint":is_sprint})
	# 应用速度
	player.velocity = velocity
	# 跳跃
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		if is_sprint:
			state_machine.change_state("SprintJump")
		else:
			state_machine.change_state("Jump")
		return

	# 攻击
	if Input.is_action_just_pressed("atk"):
		if is_sprint:
			var talent = TalentUtils.getTalent('storm_05')
			if talent && PlayerData.useMp(talent):
				state_machine.change_state("AtkSprint")
			else:
				state_machine.change_state("Atk", {'state': name})
		else:
			state_machine.change_state("Atk", {'state': name})
		return

	# 冲刺
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash",{"direction":Vector2(new_direction,0)})
		return

	if Input.is_action_just_pressed("heal"):
		state_machine.change_state("Heal")
	
	if Input.is_action_just_pressed("heal_slash"):
		state_machine.change_state("HealSlash")
	
	if Input.is_action_just_pressed("light_cut"):
		state_machine.change_state("LightCut")
	
	if Input.is_action_just_pressed("saint_heal"):
		state_machine.change_state("SaintHeal")
	
	if Input.is_action_just_pressed("shield_buff"):
		state_machine.change_state("ShieldBuff")
	
	if Input.is_action_just_pressed("sword_buff"):
		state_machine.change_state("SwordBuff")

	# 格挡
	if Input.is_action_just_pressed("block"):
		state_machine.change_state("Block")

func exit():
	is_sprint = false
	player.setAnimOffset(Vector2(0,0))
	run_time = 0.0  # 退出状态时重置计时器
