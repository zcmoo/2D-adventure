extends CanvasLayer
@export var player: Player
@export var boss: Boss
@onready var player_health_bar: TextureProgressBar = $VBoxContainer/PlayerHealthBar
@onready var eased_health_bar: TextureProgressBar = $VBoxContainer/PlayerHealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $VBoxContainer/EnergyBar
@onready var boss_health_bar: ProgressBar = $BossHealthBar


func _init() -> void:
	DamageManager.health_change.connect(on_health_change.bind())
	EnergyManager.energy_change.connect(on_energy_change.bind())

func on_health_change(character: CharacterBody2D, current_health: int, max_health: int, skip_animation: bool = false) -> void:
	var percentage = current_health / float(max_health)
	if character == player:
		player_health_bar.value = percentage
		if not skip_animation:
			create_tween().tween_property(eased_health_bar, "value", percentage, 0.3)
		else:
			eased_health_bar.value = percentage
	if character == boss:
		boss_health_bar.value = percentage
		boss_health_bar.visible = true

func on_energy_change(current_energy: float, max_energy: float) -> void:
	var percentage = current_energy / float(max_energy)
	energy_bar.value = percentage
