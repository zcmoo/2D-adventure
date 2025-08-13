class_name BoarStateRun
extends EnemyStateMachine
var time = Time.get_ticks_msec()
const DURATION = 2500


func _enter_tree() -> void:
	animation_player.play("run")
	if not enemy.is_shout:
		SoundManager.play_sfx("BoarAttack")
		enemy.is_shout = true
	enemy.speed = enemy.max_speed
	boar_hit_box.monitoring = true

func _physics_process(_delta: float) -> void:
	if boar_wall_checker.is_colliding() or not boar_floor_checker.is_colliding():
		enemy.direction *= -1
	if boar_player_checker.get_collider() is Player:
		time = Time.get_ticks_msec()
	if Time.get_ticks_msec() - time > DURATION:
		transition_boar_state(Boar.State.WALK)
	
func _exit_tree() -> void:
	boar_hit_box.monitoring = false


		


	
