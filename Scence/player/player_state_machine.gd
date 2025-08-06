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
var hit_box: Area2D = null
var hurt_box: Area2D = null
var invincible_timer: Timer = null
var attack_request_timer: Timer = null
var slide_request_timer: Timer = null


func setup(context_player: Player, context_sprite_2d: Sprite2D, context_animation_player: AnimationPlayer, context_coyote_timer: Timer, context_jump_request_timer: Timer, context_hand_checker: RayCast2D, context_foot_checker: RayCast2D, context_hit_box: Area2D, context_hurt_box: Area2D, context_invincible_timer: Timer, context_attack_request_timer: Timer, context_slide_request_timer: Timer) -> void:
	player = context_player
	sprite_2d = context_sprite_2d
	animation_player = context_animation_player
	coyote_timer = context_coyote_timer
	jump_request_timer = context_jump_request_timer
	hand_checker = context_hand_checker
	foot_checker = context_foot_checker
	hit_box = context_hit_box
	hurt_box = context_hurt_box
	invincible_timer = context_invincible_timer
	attack_request_timer = context_attack_request_timer
	slide_request_timer = context_slide_request_timer

func transition_state(new_state: Player.State) -> void:
	state_transition_requested.emit(new_state)

func on_animation_complete() -> void:
	pass # override me

func can_handle_move() -> bool:
	return true # override me

func should_fall() -> bool:
	return true # override me
