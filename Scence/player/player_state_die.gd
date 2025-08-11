class_name PlayerStateDie
extends PlayerStateMachine
var time_since_dead_move = Time.get_ticks_msec()
const DURATION_DEAD_MOVE = 300


func _enter_tree() -> void:
	animation_player.play("die")
	player.is_dead = true
	player.interacting_with.clear()
	hurt_box.monitorable = false
	invincible_timer.stop()

func _physics_process(delta: float) -> void:
	player.dead_move(delta)
	if Time.get_ticks_msec() - time_since_dead_move < DURATION_DEAD_MOVE or not player.is_on_floor():
		player.move_and_slide()

func on_animation_complete() -> void:
	hurt_box.monitorable = true
	player.is_dead = false
	get_tree().reload_current_scene()

func can_handle_move() -> bool:
	return false

func should_fall() -> bool:
	return false
