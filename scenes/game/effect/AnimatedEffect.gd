extends Node2D
class_name AnimatedEffect

@onready var sp :AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	var dir = global_position.direction_to(Game.player.global_position)
	scale.x = -1 if (dir.x > 0) else 1
	sp.animation_finished.connect(
		func finish():
			queue_free()
	)

func setEffectPosition(position:Vector2):
	global_position = position
