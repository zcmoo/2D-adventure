class_name BoarStateDie
extends EnemyStateMachine


func _enter_tree() -> void:
	animation_player.play("die")
	SoundManager.play_sfx("BoarDie")
	boar_hurt_box.monitorable = false
	enemy.is_dead = true
	
func on_animation_complete() -> void:
	enemy.is_dead = false
	enemy.queue_free()
