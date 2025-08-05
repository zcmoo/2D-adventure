class_name PlayerStateDie
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("die")
	hurt_box.monitorable = false
	invincible_timer.stop()

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	hurt_box.monitorable = true
	get_tree().reload_current_scene()
