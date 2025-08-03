extends Node
class_name  EnemyStateMachine
signal state_transition_requested(new_state: Player.State)
var enemy: Enemy = null 
var animation_player: AnimationPlayer = null

var boar_wall_checker: RayCast2D = null
var boar_floor_checker: RayCast2D = null
var boar_player_checker: RayCast2D = null


func setup_boar(context_enemy: Boar, context_animation: AnimationPlayer, context_boar_wall_checker: RayCast2D, context_boar_floor_checker: RayCast2D, context_boar_player_checker: RayCast2D) -> void:
	enemy = context_enemy
	animation_player = context_animation
	boar_wall_checker = context_boar_wall_checker
	boar_floor_checker = context_boar_floor_checker
	boar_player_checker = context_boar_player_checker

func transition_boar_state(new_state: Boar.State) -> void:
	state_transition_requested.emit(new_state)
