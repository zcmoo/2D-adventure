class_name Boss
extends CharacterBody2D
@export var player: Player
@export var damage: int
@export var health: int
@onready var graphics: Node2D = $Graphics
@onready var hit_box: Area2D = $Graphics/HitBox
@onready var hurt_box: Area2D = $Graphics/HurtBox
const SPEED = 40
const KNOCKBACK_AMOUNT = 1200
var direction: Vector2
var DEF = 0
var current_health: int


func _ready() -> void:
	current_health = health
	hit_box.area_entered.connect(on_emit_damage.bind())
	DamageReceiver.enemy_damage_receiver.connect(on_rececive_damage.bind())
	set_physics_process(false)

func _process(_delta: float) -> void:
	direction = player.position - position
	if direction.x < 0:
		graphics.scale.x = -1
	else:
		graphics.scale.x = 1

func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * SPEED
	move_and_slide()

func on_emit_damage(target_hurt_box: Area2D) -> void:
	var current_direction = Vector2.LEFT if graphics.scale.x == -1 else Vector2.RIGHT
	DamageReceiver.player_damage_receiver.emit(damage, current_direction)

func on_rececive_damage(target_hurt_box: Area2D, current_damage: int, current_direction: Vector2) -> void:
	if hurt_box == target_hurt_box:
		velocity = current_direction * KNOCKBACK_AMOUNT
		move_and_slide()
		current_health = clampi(current_health - (current_damage - DEF), 0, health)
		DamageManager.health_change.emit(self, current_health, health)
		if current_health <= health / 2 and DEF == 0:
			find_child("FiniteStateMachine").change_state("ArmcrBuff")
			DEF = 5
		if current_health == 0:
			find_child("FiniteStateMachine").change_state("Death")

		
