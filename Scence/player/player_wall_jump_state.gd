class_name PlayerWallJUMP
extends PlayerStateMachine
var time_since_stand = Time.get_ticks_msec()
const DURATION_STAND = 500


func _enter_tree() -> void:
	time_since_stand = Time.get_ticks_msec()
	player.velocity = player.WALL_JUMP_VELOCITY
	player.velocity.x *= player.get_wall_normal().x
	animation_player.play("jump")

func _physics_process(_delta: float) -> void:
	jump_request_timer.stop()
	player.move_and_slide()
	if player.is_on_wall():
		transition_state(Player.State.SLIDE)
	if player.velocity.y >= 0:
		transition_state(Player.State.FALL)

func can_handle_move() -> bool:
	if Time.get_ticks_msec() - time_since_stand < DURATION_STAND:
		return false
	return true
