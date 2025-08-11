extends BossState


func enter():
	super.enter()
	owner.hit_box.monitoring = true
	animation_player.play("melee_attack")

func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
		owner.hit_box.monitoring = false
