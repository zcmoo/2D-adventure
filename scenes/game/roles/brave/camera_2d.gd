extends Camera2D
class_name GameCamera2D

var shake_intensity = 0.0
var shake_decay = 0.8  # 衰减速度

func _ready() -> void:
	Game.camera = self
	if OS.get_name() != 'Windows':
		zoom = Vector2(1.2,1.2)

func start_shake(intensity: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(self,"offset",Vector2.ZERO,0.1).from(Vector2(0.35 * intensity,0.55 * intensity))
	#shake_intensity = intensity
