extends HBoxContainer
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var eased_health_bar: TextureProgressBar = $HealthBar/EasedHealthBar


func _init() -> void:
	DamageManager.health_change.connect(on_health_change.bind())

func on_health_change(current_health: int , max_health: int) -> void:
	var percentage = current_health / float(max_health)
	health_bar.value = percentage
	create_tween().tween_property(eased_health_bar, "value", percentage, 0.3)
