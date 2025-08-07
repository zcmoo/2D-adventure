extends Node
class_name  EnemyStateMachine
signal state_transition_requested(new_state: Player.State)
var enemy: Enemy = null 
var animation_player: AnimationPlayer = null
var boar_wall_checker: RayCast2D = null
var boar_floor_checker: RayCast2D = null
var boar_player_checker: RayCast2D = null
var boar_hit_box: Area2D = null
var boar_hurt_box: Area2D = null


func setup_boar(context_enemy: Boar, context_animation: AnimationPlayer, context_boar_wall_checker: RayCast2D, context_boar_floor_checker: RayCast2D, context_boar_player_checker: RayCast2D, context_boar_hit_box: Area2D, context_boar_hurt_box: Area2D) -> void:
	enemy = context_enemy
	animation_player = context_animation
	boar_wall_checker = context_boar_wall_checker
	boar_floor_checker = context_boar_floor_checker
	boar_player_checker = context_boar_player_checker
	boar_hit_box = context_boar_hit_box
	boar_hurt_box = context_boar_hurt_box

func transition_boar_state(new_state: Boar.State) -> void:
	state_transition_requested.emit(new_state)

func on_animation_complete() -> void:
	pass # override me

func can_handle_move() -> bool:
	return true # override me
