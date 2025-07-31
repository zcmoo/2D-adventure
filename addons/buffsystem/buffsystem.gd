@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("BuffConsts","res://addons/buffsystem/BuffConsts.gd")
	add_autoload_singleton("BuffManager","res://addons/buffsystem/BuffManager.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("BuffConsts")
	remove_autoload_singleton("BuffManager")
