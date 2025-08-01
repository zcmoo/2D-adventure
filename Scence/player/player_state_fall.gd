class_name PlayerStateFall
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("fall")

func _physics_process(delta: float) -> void:
	player.move_and_slide()
	if player.coyote_timer.time_left > 0 and jump_request_timer.time_left > 0:
		player.velocity.y = player.JUMP_VELOCITY
		transition_state(Player.State.JUMP)
	if player.is_on_floor() and player.velocity == Vector2.ZERO:
		if jump_request_timer.time_left > 0:
			transition_state(Player.State.JUMP)
		else:
			transition_state(Player.State.Land)
	elif player.is_on_floor() and player.velocity != Vector2.ZERO:
		transition_state(Player.State.MOVE)
		
	
	
