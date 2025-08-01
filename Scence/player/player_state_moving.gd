class_name PlayerStateMove
extends PlayerStateMachine


func _physics_process(delta: float) -> void:
	if is_zero_approx(player.direction) and is_zero_approx(player.velocity.x):
		animation_player.play("idle")
	else:
		animation_player.play("running")
	var was_on_floor = player.is_on_floor()
	player.move_and_slide()
	if player.is_on_floor() != was_on_floor:
		if was_on_floor :
			coyote_timer.start()
			transition_state(Player.State.FALL)
		else:
			coyote_timer.stop()
	if player.is_on_floor() and jump_request_timer.time_left > 0:
		transition_state(Player.State.JUMP)



		
		
		
		



 
	
	
