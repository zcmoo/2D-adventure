extends Control


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)

func _on_quit_pressed() -> void:
	GameManager.back_to_title()
