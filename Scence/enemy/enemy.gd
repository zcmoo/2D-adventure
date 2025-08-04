class_name Enemy
extends CharacterBody2D
enum Direction {LEFT = -1, RIGHT = +1}
@onready var graphics: Node2D = $Graphics
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: Area2D = $Graphics/HitBox
@onready var hurt_box: Area2D = $Graphics/HurtBox
@export var direction = Direction.LEFT
@export var max_speed: float = 180.0
@export var acceleration: float = 2000.0
@export var damage: int
@export var health: int
const KNOCKBACK_AMOUNT = 650.0
var speed: float
var gravity = ProjectSettings.get("physics/2d/default_gravity") as float
var current_state: EnemyStateMachine = null
var state_factory: EnemyStateFactory = EnemyStateFactory.new()
var is_hurting: bool = false


func _ready() -> void:
	hit_box.area_entered.connect(on_emit_damage.bind())
	DamageReceiver.enemy_damage_receiver.connect(on_rececive_damage.bind())

func _physics_process(delta: float) -> void:
	if is_on_floor():
		set_heading()
	if health > 0:
		handle_move(delta)
	elif health == 0 or is_hurting:
		stand(delta)
	move_and_slide()

func set_heading() -> void:
	graphics.scale.x = -1 * direction

func handle_move(delta) -> void:
	velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	velocity.y += gravity * delta

func on_emit_damage(target_hurt_box: Area2D) -> void:
	var current_direction = Vector2.LEFT if direction == Direction.LEFT else Vector2.RIGHT
	DamageReceiver.player_damage_receiver.emit(damage, current_direction)

func on_rececive_damage(target_hurt_box: Area2D, current_damage: int, current_direction: Vector2) -> void:
	if hurt_box == target_hurt_box:
		health = clampi(health - current_damage, 0, health)
		velocity = current_direction * KNOCKBACK_AMOUNT
		if current_direction.x > 0:
			direction = Direction.LEFT
		else:
			direction = Direction.RIGHT

func stand(delta) -> void:
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta
