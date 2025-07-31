extends State

func enter(param = {}):
	var _pos = player.global_position - (player.get_facing_direction() * 10)
	EffectUtils.addSprintAtkEffect(_pos)
	
	player.setAnimOffset(Vector2(0,-6))

	player.velocity.y = -120
	player.changeAnim("sprint_atk",func finish():
		if state_machine.current_state == self:
			state_machine.change_state("Idle")
	)
	player.anim_player.frame_changed.connect(self.frame_changed)
	
func frame_changed():
	if player.anim_player.animation == 'sprint_atk':
		if player.anim_player.frame > 4 and player.anim_player.frame < 7:
			var enemies = player.checkHit('sprint_atk')
			if enemies.size() > 0:
				playAudios('atk_3_hit')
				for enemy in enemies:
					EffectUtils.addSwordEffect(enemy.global_position)
					enemy.take_damage(1)
					Game.knockback(player,enemy,150)
		if player.anim_player.frame == 7:
			player.velocity.x = 0
			player.velocity.y = 0

func playAudios(anim_name):
	Game.camera.start_shake(3.6)
	Game.scale_frame(0.15,0.4)
	player.playAudios(anim_name)

func exit():
	player.anim_player.frame_changed.disconnect(self.frame_changed)
	
	player.setAnimOffset(Vector2.ZERO)
