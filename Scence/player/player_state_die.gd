class_name PlayerStateDie
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("die")
	invincible_timer.stop()
	player.velocity = player.hurt_direction * 200 

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	get_tree().reload_current_scene()
