class_name BoarStateHurt
extends EnemyStateMachine


func _enter_tree() -> void:
	animation_player.play("hit")
	enemy.hurt_box.monitorable = false
	enemy.is_hurting = true

func on_animation_complete() -> void:
	transition_boar_state(Boar.State.RUN)

func _exit_tree() -> void:
	enemy.hurt_box.monitorable = true
	enemy.is_hurting = false

func can_handle_move() -> bool:
	return false 
