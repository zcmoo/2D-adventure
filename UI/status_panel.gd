extends HBoxContainer
@export var player: Player
@onready var health_bar: TextureProgressBar = $VBoxContainer/HealthBar
@onready var eased_health_bar: TextureProgressBar = $VBoxContainer/HealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $VBoxContainer/EnergyBar


func _init() -> void:
	DamageManager.health_change.connect(on_health_change.bind())
	EnergyManager.energy_change.connect(on_energy_change.bind())

func on_health_change(character: CharacterBody2D, current_health: int, max_health: int, skip_animation: bool = false) -> void:
	if character == player:
		var percentage = current_health / float(max_health)
		health_bar.value = percentage
		if not skip_animation:
			create_tween().tween_property(eased_health_bar, "value", percentage, 0.3)
		else:
			eased_health_bar.value = percentage

func on_energy_change(current_energy: float, max_energy: float) -> void:
	var percentage = current_energy / float(max_energy)
	energy_bar.value = percentage
