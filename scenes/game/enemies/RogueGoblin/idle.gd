extends EnemyState

@onready var timer = $Timer

func enter(params = {}):
	#timer.start()
	player.changeAnim("idle")
	player.velocity.x = 0


func exit():
	if timer:
		timer.stop()
