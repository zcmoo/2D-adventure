class_name BoarStateIDLE
extends EnemyStateMachine
var time_since_idle_state = Time.get_ticks_msec()
const DURATION_IDLE_STATE = 2000


func _enter_tree() -> void:
	if boar_wall_checker.is_colliding():
		enemy.direction *= -1
	enemy.speed = 0.0
	animation_player.play("idle")
	time_since_idle_state = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	if boar_player_checker.is_colliding():
		transition_boar_state(Boar.State.RUN)
	if Time.get_ticks_msec() - time_since_idle_state > DURATION_IDLE_STATE:
		transition_boar_state(Boar.State.WALK)
