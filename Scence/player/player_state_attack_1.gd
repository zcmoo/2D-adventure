class_name PlayerStateAttack_1
extends PlayerStateMachine


func _enter_tree() -> void:
	attack_request_timer.stop()
	animation_player.play("attack_1")
	SoundManager.play_sfx("Attack")
	player.is_combo_requested = false
	hit_box.monitoring = true

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()
	if not animation_player.is_playing():
		if player.is_combo_requested:
			transition_state(Player.State.ATTACK_2)
		else:
			hit_box.monitoring = false
			transition_state(Player.State.MOVE)

func can_handle_move() -> bool:
	return false

func should_fall() -> bool:
	return false



	
