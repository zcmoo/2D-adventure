extends Node2D

@onready var part = $GPUParticles2D

func _ready() -> void:
	part.emitting = true
	await part.finished
	queue_free()

func setEffectPosition(_pos):
	global_position = _pos
