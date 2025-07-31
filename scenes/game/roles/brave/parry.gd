extends State

enum BlockState { BLOCK_START, BLOCKING, BLOCK_END }
var current_state: BlockState = BlockState.BLOCK_START
var current_direction = 0
var is_block_atk = false
var is_try_block_atk = false # 是否尝试进行铁山靠

func preMethod():
	#return TalentUtils.player_talents.has("block_02")
	return true

func enter(params = {}):
	player.anim_player.flip_h = true
	player.setAnimOffset(Vector2(0,-10))
	is_block_atk = false
	player.velocity.x = 0  # 停止角色移动
	player.changeAnim("parry_start", func():
		if state_machine.current_state == self:
			state_machine.change_state("Idle"))
	player.anim_player.frame_changed.connect(self.frame_changed)

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
	Game.time_scale_frame(0.1,0.15)
	player.playAudios(anim_name)

# 格挡成功
func doBlock(enemy:Enemy):
	var dir = ceili(player.global_position.direction_to(enemy.global_position).x)
	if dir == player.get_facing_direction().x && is_block_atk == false:
		player.changeShieldHp(-20)
		if player.shield_hp <= 0:
			player.playAudios('blockbreak')
			player.changeAnim("block_break", func finish():
				if state_machine.current_state == self:
					exit()
			)
			Game.time_scale_frame(0.1,0.2)
			Game.knockback(enemy,player,100)
		else:
			player.playAudios('block')
			player.changeAnim("block_suc", func finish():
				if state_machine.current_state == self:
					player.changeAnim("block_ing")
			)
			Game.time_scale_frame(0.1,0.3)
		#Game.scale_frame(0.08,0.3)
	else:
		state_machine.change_state("Hit")

func exit():
	if player.anim_player.frame_changed.is_connected(self.frame_changed):
		player.anim_player.frame_changed.disconnect(self.frame_changed)
	is_block_atk = false
	player.setAnimOffset(Vector2.ZERO)
	player.anim_player.flip_h = false
	current_direction = 0


func _on_timer_timeout() -> void:
	player.changeShieldHp(1)
