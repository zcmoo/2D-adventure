class_name PlayerStateFall
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("fall")
	player.fall_from_y = player.global_position.y

func _physics_process(_delta: float) -> void:
	player.move_and_slide()
	if player.coyote_timer.time_left > 0 and jump_request_timer.time_left > 0:
		player.velocity.y = player.JUMP_VELOCITY
		transition_state(Player.State.JUMP)
	if player.is_on_floor():
		var height = player.global_position.y - player.fall_from_y
		if player.velocity == Vector2.ZERO:
			if jump_request_timer.time_left > 0:
				transition_state(Player.State.JUMP)
			if height > player.LANDING_HEIGHT:
				if height > player.DAMMAGE_HEIGHT:
					player.current_health = clampi(player.current_health - player.HEIGHT_DAMMAGE, 0, player.health)
					DamageManager.health_change.emit(player.current_health, player.health)
				transition_state(Player.State.Land)
			else:
				transition_state(Player.State.MOVE)
		else:
			transition_state(Player.State.MOVE)
	if player.is_on_wall() and hand_checker.is_colliding() and foot_checker.is_colliding():
		transition_state(Player.State.SLIDE)
		

	
