class_name PlayerStateMove
extends PlayerStateMachine


func _physics_process(_delta: float) -> void:
	if is_zero_approx(player.direction) and is_zero_approx(player.velocity.x):
		animation_player.play("idle")
	else:
		animation_player.play("running")
	var was_on_floor = player.is_on_floor()
	player.move_and_slide()
	if player.is_on_floor() != was_on_floor:
		if was_on_floor :
			coyote_timer.start()
		else:
			coyote_timer.stop()
	if hurt_box.monitorable == false:
		hurt_box.monitorable = true
	if hit_box.monitoring == true:
		hit_box.monitoring = false
	if jump_request_timer.time_left > 0:
		transition_state(Player.State.JUMP)
	if attack_request_timer.time_left > 0:
		transition_state(Player.State.ATTACK_1)
	if slide_request_timer.time_left > 0 and player.current_energy > player.SLIDE_ENERGY:
		transition_state(Player.State.SLID_START)
	if player.current_health == 0:
		transition_state(Player.State.DIE)



		
		
		
		



 
	
	
