extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()
	set_process_input(false)

func _input(event: InputEvent) -> void:
	get_window().set_input_as_handled()  

func show_game_over() -> void:
	show()
	set_process_input(true)
	animation_player.play("enter")
	SoundManager.stop_all_sfx()
	SoundManager.player_bgm(preload("res://assets/声音/level-win-6416.mp3"))
	await get_tree().create_timer(3.6).timeout
	GameManager.back_to_title()

		
		
