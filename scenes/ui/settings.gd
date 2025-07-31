extends ColorRect

@onready var panel = $Panel

func _ready() -> void:
	Game.settings_ui = self
	Game.on_canvas_mode_changed.connect(self.on_canvas_mode_changed)

func on_canvas_mode_changed(_mode):
	if _mode == Game.CanvasMode.ADD:
		show()
		panel.visible = false
		mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	elif _mode == Game.CanvasMode.POSITION:
		panel.visible = false
		mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	else:
		panel.visible = true
		mouse_filter = MouseFilter.MOUSE_FILTER_STOP

func _on_key_settings_pressed() -> void:
	Game.canvas_mode = Game.CanvasMode.POSITION

func _on_back_pressed() -> void:
	visible = false


func _on_joy_1_pressed(argument_1:bool) -> void:
	if argument_1:
		Game.move_mode = Game.MoveMode.JOY
	else:
		Game.move_mode = Game.MoveMode.NOR
