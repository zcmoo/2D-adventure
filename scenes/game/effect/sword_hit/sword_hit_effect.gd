extends AnimatedEffect

func _ready() -> void:
	$GPUParticles2D.emitting = true
	var dir = global_position.direction_to(Game.player.global_position)
	scale.x = 1 if (dir.x > 0) else -1
	sp.animation_finished.connect(
		func finish():
			queue_free()
	)
