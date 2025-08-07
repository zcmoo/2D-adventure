class_name PlayerStateAttack_3
extends PlayerStateMachine


func _enter_tree() -> void:
	player.is_combo_requested = false
	hit_box.monitoring = true
	animation_player.play("attack_3")

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	transition_state(Player.State.MOVE)

func can_handle_move() -> bool:
	return false

func _exit_tree() -> void:
	hit_box.monitoring = false
