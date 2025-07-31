extends CanvasLayer

@onready var _input_ui = $InputUI

func _ready() -> void:
	Game.game_ui = self
	Game.input_ui = _input_ui

func moveInputStart():
	move_child(_input_ui,0)

func moveInputEnd():
	move_child(_input_ui,get_child_count()-1)
