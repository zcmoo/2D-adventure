class_name BoarStateWalk
extends EnemyStateMachine


func _enter_tree() -> void:
	if not boar_floor_checker.is_colliding():
		enemy.direction *= -1
	enemy.speed = enemy.max_speed / 3.0
	animation_player.play("walk")

func _physics_process(_delta: float) -> void:
	if boar_player_checker.is_colliding():
		transition_boar_state(Boar.State.RUN)
	if boar_wall_checker.is_colliding() or not boar_floor_checker.is_colliding():
		transition_boar_state(Boar.State.IDLE)

		
		
