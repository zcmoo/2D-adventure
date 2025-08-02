class_name  PlayerStateMachine
extends Node
signal state_transition_requested(new_state: Player.State)
var player: Player = null 
var sprite_2d: Sprite2D = null
var animation_player: AnimationPlayer = null
var coyote_timer: Timer = null
var jump_request_timer: Timer = null
var hand_checker: RayCast2D = null
var foot_checker: RayCast2D = null


func setup(context_player: Player, context_sprite_2d: Sprite2D, context_animation_player: AnimationPlayer, context_coyote_timer: Timer, context_jump_request_timer: Timer, context_hand_checker: RayCast2D, context_foot_checker: RayCast2D) -> void:
	player = context_player
	sprite_2d = context_sprite_2d
	animation_player = context_animation_player
	coyote_timer = context_coyote_timer
	jump_request_timer = context_jump_request_timer
	hand_checker = context_hand_checker
	foot_checker = context_foot_checker

func transition_state(new_state: Player.State) -> void:
	state_transition_requested.emit(new_state)

func on_animation_complete() -> void:
	pass # override me

func can_handle_move() -> bool:
	return true # override
