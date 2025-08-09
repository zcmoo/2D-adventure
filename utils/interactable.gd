class_name Interactable
extends Area2D
signal interacted


func _ready() -> void:  
	collision_layer = 0
	set_collision_mask_value(2, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func interact() -> void:
	interacted.emit()

func _on_body_entered(body: Object) -> void:
	if body is Player: 
		var player = body as Player
		player.register_interactable(self)

func _on_body_exited(body: Object) -> void:
	if body is Player:  
		var player = body as Player
		player.unregister_interactable(self)
