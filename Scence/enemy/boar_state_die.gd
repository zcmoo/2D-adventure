class_name BoarStateDie
extends EnemyStateMachine


func _enter_tree() -> void:
	animation_player.play("die")

func on_animation_complete() -> void:
	enemy.queue_free()
