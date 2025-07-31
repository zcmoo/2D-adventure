extends EnemyState

var velocity = Vector2.ZERO  # 水平和垂直速度

func enter(param = {}):
	player.changeAnim("run")

func update(delta):
	
	if Engine.get_physics_frames() % 5 == 0:
		var hit_body = player.checkAtk()
	
		if hit_body:
			state_machine.change_state("Atk")
			return

	velocity = player.velocity
	
	var dir = player.global_position.direction_to(Game.player.global_position)
	
	if dir:
		velocity.x = dir.x * player.speed
		player.flip_h(dir.x < 0)
	
	player.velocity = velocity
