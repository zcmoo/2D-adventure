class_name BoarStateRun
extends EnemyStateMachine
var time = Time.get_ticks_msec()
const DURATION = 2500


func _enter_tree() -> void:
	animation_player.play("run")
	enemy.speed = enemy.max_speed

func _physics_process(_delta: float) -> void:
	if boar_wall_checker.is_colliding() or not boar_floor_checker.is_colliding():
		enemy.direction *= -1
	if boar_player_checker.is_colliding():
		time = Time.get_ticks_msec()
	if Time.get_ticks_msec() - time > DURATION:
		transition_boar_state(Boar.State.WALK)
		


	
