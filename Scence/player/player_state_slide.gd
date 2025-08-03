class_name PlayerStateSlide
extends PlayerStateMachine
var default_gravity
var slide_gravity


func _enter_tree() -> void:
	player.velocity.y = 0.0
	default_gravity = player.gravity
	slide_gravity = player.gravity / 10
	player.gravity = slide_gravity
	animation_player.play("wall_sliding")

func _physics_process(_delta: float) -> void:
	player.move_and_slide()
	if player.is_on_floor():
		transition_state(Player.State.MOVE)
	elif not player.is_on_wall():
		transition_state(Player.State.FALL)
	elif player.is_on_wall() and player.jump_request_timer.time_left > 0:
		transition_state(Player.State.WALL_JUMP)

func _exit_tree() -> void:
	player.gravity = default_gravity
