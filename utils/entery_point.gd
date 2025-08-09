class_name EntryPoint
extends Marker2D
@export var direction = Player.Direction.LEFT


func _ready() -> void:
	add_to_group("entry_points")
	
