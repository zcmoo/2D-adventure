extends HBoxContainer
@onready var health_bar: TextureProgressBar = $VBoxContainer/HealthBar
@onready var eased_health_bar: TextureProgressBar = $VBoxContainer/HealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $VBoxContainer/EnergyBar


func _init() -> void:
	DamageManager.health_change.connect(on_health_change.bind())
	EnergyManager.energy_change.connect(on_energy_change.bind())

func on_health_change(current_health: int , max_health: int) -> void:
	var percentage = current_health / float(max_health)
	health_bar.value = percentage
	create_tween().tween_property(eased_health_bar, "value", percentage, 0.3)

func on_energy_change(current_energy: float, max_energy: float) -> void:
	var percentage = current_energy / float(max_energy)
	energy_bar.value = percentage
	
