extends Node

const config_path = "user://config.cfg"

var config = ConfigFile.new()

func _ready() -> void:
	if config.load(config_path) != OK:
		config.save(config_path)
		config.load(config_path)

func loadKeyPosition():
	if config.has_section("key_position"):
		for key in config.get_section_keys("key_position"):
			pass

func setKeyPosition(key,position):
	config.set_value('key_position',key,position)
	config.save(config_path)

func getKeyPosition(key):
	if config.has_section_key('key_position',key):
		return config.get_value('key_position',key)
	return null
