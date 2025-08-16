extends Camera2D
var strength = 0.0
@export var recovery_speed = 16.0


func _ready() -> void:
	GameManager.camera_should_shake.connect(func (amount:float):
		strength += amount
	)

func _physics_process(delta: float) -> void:
	offset = Vector2(
		randf_range(-strength, +strength),
		randf_range(-strength, +strength)
	)
	strength = move_toward(strength, 0, recovery_speed)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("camera_scale"):
		#set_zoom(Vector2(0.6, 0.6))
		#return
	#if event.is_action_released("camera_scale"):
		#set_zoom(Vector2(1, 1))
		#return
