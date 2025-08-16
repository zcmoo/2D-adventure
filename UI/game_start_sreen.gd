extends Control


func _ready() -> void:
	await get_tree().create_timer(3.5).timeout
	GameManager.new_game()
