class_name PlayerStateSlideEnd
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("slide_end")

func _physics_process(delta: float) -> void:
	player.common_stand(delta)
	player.move_and_slide()

func on_animation_complete() -> void:
	transition_state(Player.State.MOVE)

func can_handle_move() -> bool:
	return false

func _exit_tree() -> void:
	hurt_box.monitorable = true	
