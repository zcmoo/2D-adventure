extends EnemyState

func enter(param = {}):
	player.is_atking = true
	player.anim_player.frame_changed.connect(self.frame_changed)
	
	player.velocity.x = 0
	player.anim_player.offset.y = -9
	
	player.changeAnim("atk_1",func finish():
		state_machine.change_state("Idle")
	)
	player.velocity.x = player.get_facing_direction().x * player.speed

func frame_changed():
	if player.anim_player.animation == 'atk_1' && player.anim_player.frame == 4:
		check_hit(1)
	if player.anim_player.animation == 'atk_1' && player.anim_player.frame == 9:
		check_hit(2)
	if player.anim_player.animation == 'atk_1' && player.anim_player.frame == 21:
		check_hit(3)
	player.velocity.x = 0

func update(delta):
	var dir = player.global_position.direction_to(Game.player.global_position)
	
	if dir:
		player.flip_h(dir.x < 0)

func check_hit(combo_count):
	var is_hit = false
	var damage = combo_count * 10  # 假设每段伤害递增
	var hit_body = player.checkAtk()
	if hit_body && hit_body is Player:
		hit_body.take_damage(damage,player)
		Game.knockback(player,hit_body,20)

func exit():
	player.is_atking = false
	player.anim_player.offset.y = 0
	player.anim_player.frame_changed.disconnect(self.frame_changed)
