extends HSlider
@export var bus: String = "Master"
@onready var bus_index = AudioServer.get_bus_index(bus)


func _ready() -> void:
	value = SoundManager.get_volume(bus_index)
	value_changed.connect(func (v:float):
		SoundManager.set_volume(bus_index, v)
		GameManager.save_config()
	)
	SoundManager.player_bgm(preload("res://assets/bgm/29 15 game over LOOP.mp3"))
