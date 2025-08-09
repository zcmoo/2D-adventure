class_name Teleporter
extends Interactable
@export_file("*.tscn") var path: String
@export var entry_point: String


func interact() -> void:
	super.interact()
	GameManager.change_scene(path, entry_point)
