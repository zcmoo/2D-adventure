extends Area2D
@export var damage: int
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

func _on_area_entered(area: Area2D) -> void:
	var current_direction = Vector2.LEFT if global_position.x > player.global_position.x else Vector2.RIGHT 
	DamageReceiver.player_damage_receiver.emit(damage, current_direction)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
