class_name PlayerStateSlideLOOP
extends PlayerStateMachine
var time_since_slide_loop_state = Time.get_ticks_msec()
const DURATION_SLIDE_LOOP_STATE = 500


func _enter_tree() -> void:
	time_since_slide_loop_state = Time.get_ticks_msec()
	hurt_box.monitorable = false
	animation_player.play("slide_loop")

func _physics_process(delta: float) -> void:
	player.slide(delta)
	player.move_and_slide()
	if Time.get_ticks_msec() - time_since_slide_loop_state > DURATION_SLIDE_LOOP_STATE or player.is_on_wall():
		transition_state(Player.State.SLID_END)

func can_handle_move() -> bool:
	return false

func _exit_tree() -> void:
	hurt_box.monitorable = true
