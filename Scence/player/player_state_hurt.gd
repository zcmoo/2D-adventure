class_name PlayerStateHurt
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("hurt")
	invincible_timer.start()
	player.velocity = player.hurt_direction * player.KNOCKBACK_AMOUNT
	hurt_box.monitorable = false
	player.is_hurting = true

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	transition_state(Player.State.MOVE)

func _exit_tree() -> void:
	hurt_box.monitorable = true
	player.is_hurting = false
