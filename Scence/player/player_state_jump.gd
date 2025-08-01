class_name PlayerStateJump
extends PlayerStateMachine


func _enter_tree() -> void:
	player.velocity.y = player.JUMP_VELOCITY
	animation_player.play("jump")

func _physics_process(delta: float) -> void:
	coyote_timer.stop()
	jump_request_timer.stop()
	player.move_and_slide()
	if player.velocity.y >= 0:
		transition_state(Player.State.FALL)
	
