class_name PlayerStateLand
extends PlayerStateMachine


func _enter_tree() -> void:
	animation_player.play("landing")

func on_animation_complete() -> void:
	transition_state(Player.State.MOVE)
	
