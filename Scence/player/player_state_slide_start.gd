class_name PlayerStateSlideStart
extends PlayerStateMachine


func _enter_tree() -> void:
	slide_request_timer.stop()
	animation_player.play("slid_start")
	player.current_energy = clampf(player.current_energy - player.SLIDE_ENERGY, 0, player.energy)
	EnergyManager.energy_change.emit(player.current_energy, player.energy)

func _physics_process(delta: float) -> void:
	player.slide(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	transition_state(Player.State.SLID_LOOP)

func can_handle_move() -> bool:
	return false
