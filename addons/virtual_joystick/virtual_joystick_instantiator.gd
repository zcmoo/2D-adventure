@tool
extends Control

var scene

func _ready() -> void:
	Game.on_canvas_mode_changed.connect(self.on_canvas_mode_changed)

func on_canvas_mode_changed(_mode):
	if _mode == Game.CanvasMode.NOR:
		modulate.a = 0.8
	else:
		modulate.a = 1

func _enter_tree():
	scene = preload("res://addons/virtual_joystick/virtual_joystick_scene.tscn").instantiate()
	add_child(scene)
	
	if ProjectSettings.get_setting("input_devices/pointing/emulate_mouse_from_touch"):
		printerr("The Project Setting 'emulate_mouse_from_touch' should be set to False")
	if not ProjectSettings.get_setting("input_devices/pointing/emulate_touch_from_mouse"):
		printerr("The Project Setting 'emulate_touch_from_mouse' should be set to True")


func _exit_tree():
	scene.free()

var dragging = false
