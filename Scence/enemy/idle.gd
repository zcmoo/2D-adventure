extends BossState
@onready var player_dectetion_collision_shape_2d: CollisionShape2D = $"../../PlayerDectetion/PlayerDectetionCollisionShape2D"
@onready var point_light_2d: PointLight2D = $"../../PointLight2D"
var player_entered: bool = false:
	set(value):
		player_entered = value
		player_dectetion_collision_shape_2d.set_deferred("disabled", value)


func transition():
	if player_entered:
		get_parent().change_state("Follow")

func _on_player_dectetion_body_entered(body: Node2D) -> void:
	player_entered = true	
	point_light_2d.visible = true
	
