extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var player: Player


func _physics_process(delta):
	acceleration = (player.position - position).normalized() * 700
	velocity += acceleration * delta
	rotation = velocity.angle()
	velocity = velocity.limit_length(150)
	position += velocity * delta
 
func _on_body_entered(body: Node2D) -> void:
	queue_free()
