class_name PlayerStateHurt
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("hurt")
	invincible_timer.start()
	player.velocity.x = player.hurt_direction.x * player.KNOCKBACK_AMOUNT
	hurt_box.monitorable = false
	hit_box.monitoring = false
	player.is_hurting = true

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	transition_state(Player.State.MOVE)

func can_handle_move() -> bool:
	return false

func _exit_tree() -> void:
	hurt_box.monitorable = true
	player.is_hurting = false
