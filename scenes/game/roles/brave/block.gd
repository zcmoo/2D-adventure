extends State

enum BlockState { BLOCK_START, BLOCKING, BLOCK_END }
var current_state: BlockState = BlockState.BLOCK_START
var current_direction = 0
var is_block_atk = false
var is_try_block_atk = false # 是否尝试进行铁山靠

func preMethod():
	return TalentUtils.player_talents.has("block_02")

func enter(params = {}):
	is_block_atk = false
	#current_direction = player.get_facing_direction().x
	current_state = BlockState.BLOCK_START
	player.velocity.x = 0  # 停止角色移动
	if params.has("block_ing"):
		current_state = BlockState.BLOCKING
		player.changeAnim("block_ing") 
	else:
		# 播放进入格挡动画并等待完成
		player.changeAnim("block_start", func():
			if current_state == BlockState.BLOCK_START:  # 确保状态一致
				current_state = BlockState.BLOCKING
				player.shiled_ui.visible = true
				player.changeAnim("block_ing")  # 持续格挡动作
		)
	player.anim_player.frame_changed.connect(self.frame_changed)

func update(delta):
	if Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash")
		return
	
	match current_state:
		BlockState.BLOCK_START:
			if Input.is_action_just_pressed("atk"):
				#state_machine.change_state("Atk",{'state':name})
				state_machine.change_state("BlockAtk",{'state':name})
				return
			# 起手阶段等待动画完成，不处理输入
			pass

		BlockState.BLOCKING:
			if Input.is_action_just_pressed("move_left"):
				current_direction = -1
			elif Input.is_action_just_pressed("move_right"):
				current_direction = 1
			
			if current_direction != 0:
				player.flip_h(current_direction)
				if is_block_atk == false:
					tryBlockAtk()
				current_direction = 0
		
			if Input.is_action_just_pressed("atk"):
				#state_machine.change_state("Atk",{'state':name})
				state_machine.change_state("BlockAtk",{'state':name})
				return
			
			if not Input.is_action_pressed("block"):
				exit()  # 松开按键退出格挡
		BlockState.BLOCK_END:
			state_machine.atkInputEvent()
			pass

# 盾牌猛击
func tryBlockAtk():
	var talent = TalentUtils.getTalent('block_03')
	if talent && PlayerData.useMp(talent):
		is_block_atk = true
		player.setAnimOffset(Vector2(0,-10))
		player.changeAnim("block_atk",func finish():
			if state_machine.current_state == self:
				player.setAnimOffset(Vector2.ZERO)
				player.changeAnim('block_ing')
				current_direction = 0
				is_block_atk = false
			)

func frame_changed():
	# 盾牌猛击
	if player.anim_player.animation == 'block_atk' and player.anim_player.frame == 8:
		var enemies = player.checkHit('block_atk')
		if enemies.size() > 0:
			playAudios('atk_2_hit')
			for enemy in enemies:
				EffectUtils.addSwordEffect(enemy.global_position)
				enemy.take_damage(1)
				Game.knockback(player,enemy,150)

func playAudios(anim_name):
	Game.camera.start_shake(3.6)
	#Game.scale_frame(0.15,0.4)
	Game.time_scale_frame(0.1,0.15)
	player.playAudios(anim_name)

# 格挡成功
func doBlock(enemy:Enemy):
	var dir = ceili(player.global_position.direction_to(enemy.global_position).x)
	#print(player.get_facing_direction().x)
	
	if dir == player.get_facing_direction().x && is_block_atk == false:
		player.changeShieldHp(-20)
		if player.shield_hp <= 0:
			player.playAudios('blockbreak')
			player.changeAnim("block_break", func finish():
				if state_machine.current_state == self:
					exit()
			)
			#Game.freeze_frame(0.1)
			Game.time_scale_frame(0.2,0.1)
			Game.knockback(enemy,player,100)
		else:
			player.playAudios('block')
			player.changeAnim("block_suc", func finish():
				if state_machine.current_state == self:
					player.changeAnim("block_ing")
			)
			Game.time_scale_frame(0.1,0.2)
		#Game.scale_frame(0.08,0.3)
	else:
		state_machine.change_state("Hit")

func exit():
	if player.anim_player.frame_changed.is_connected(self.frame_changed):
		player.anim_player.frame_changed.disconnect(self.frame_changed)
	is_block_atk = false
	player.setAnimOffset(Vector2.ZERO)
	current_direction = 0
	player.shiled_ui.visible = false
	if current_state != BlockState.BLOCKING:
		return  # 防止重复调用
	current_state = BlockState.BLOCK_END

	# 播放收手动画并在完成后切换到 Idle
	player.changeAnim("block_end", func():
		if state_machine.current_state == self:
			state_machine.change_state("Idle")
	)


func _on_timer_timeout() -> void:
	player.changeShieldHp(1)
