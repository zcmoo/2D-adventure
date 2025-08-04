class_name BoarStateHurt
extends EnemyStateMachine


func _enter_tree() -> void:
	animation_player.play("hit")
	enemy.is_hurting = true

func on_animation_complete() -> void:
	enemy.is_hurting = false
	transition_boar_state(Boar.State.RUN)
