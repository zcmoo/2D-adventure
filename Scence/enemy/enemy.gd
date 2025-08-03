class_name Enemy
extends CharacterBody2D
enum Direction {LEFT = 1, RIGHT = +1}
@onready var graphics: Node2D = $Graphics
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var direction = Direction.LEFT
@export var max_speed: float = 180.0
@export var acceleration: float = 2000.0
var speed: float
var gravity = ProjectSettings.get("physics/2d/default_gravity") as float
var current_state: EnemyStateMachine = null
var state_factory: EnemyStateFactory = EnemyStateFactory.new()


func _physics_process(delta: float) -> void:
	set_heading()
	handle_move(delta)
	move_and_slide()

func set_heading() -> void:
	graphics.scale.x = -1 * direction

func handle_move(delta) -> void:
	velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	velocity.y += gravity * delta
