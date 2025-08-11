extends BossState


func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	if distance > 200:
		get_parent().change_state("Dash")
	elif distance < 150 and distance > 100:
		get_parent().change_state("HomingMissile")
	elif distance <= 50:
		var chance = randi() % 3
		match chance:
			0:
				get_parent().change_state("HomingMissile")
			1:
				get_parent().change_state("LaserBean")
			2:
				get_parent().change_state("LaserBean")
	else:
		pass
