class_name BoarStateDie
extends EnemyStateMachine


func _enter_tree() -> void:
	animation_player.play("die")
	boar_hurt_box.monitorable = false
	enemy.is_dead = true

func on_animation_complete() -> void:
	enemy.queue_free()
