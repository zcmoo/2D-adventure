extends Control
@onready var new_game: Button = $V/NewGame
@onready var v: VBoxContainer = $V
@onready var load_game: Button = $V/LoadGame


func _ready() -> void:
	load_game.disabled = not GameManager.has_save()
	new_game.grab_focus()
	for button: Button in v.get_children():
		button.mouse_entered.connect(button.grab_focus)
	SoundManager.player_bgm(preload("res://assets/bgm/02 1 titles LOOP.mp3"))
	SoundManager.setup_ui_sounds(self)

func _on_new_game_pressed() -> void:
	GameManager.new_game()

func _on_load_game_pressed() -> void:
	GameManager.load_game()

func _on_exit_game_pressed() -> void:
	get_tree().quit()
