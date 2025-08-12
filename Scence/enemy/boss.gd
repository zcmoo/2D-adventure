class_name Boss
extends CharacterBody2D
@export var player: Player
@export var damage: int
@export var health: int
@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var point_light_2d_2: PointLight2D = $HitBox/PointLight2D2
const SPEED = 80
const KNOCKBACK_AMOUNT = 1500
var direction: Vector2
var direction_shoot: Vector2
var DEF = 0
var current_health: int
var player_attack_point_global_position: Vector2
var can_move: bool = true


func _ready() -> void:
	current_health = health
	hit_box.area_entered.connect(on_emit_damage.bind())
	DamageReceiver.enemy_damage_receiver.connect(on_rececive_damage.bind())
	point_light_2d.visible = false
	point_light_2d_2.visible = false
	set_physics_process(false)

func _process(_delta: float) -> void:
	player_attack_point_global_position = player.attack_point.global_position if player.attack_point.global_position.x - global_position.x > 0 else player.attack_point_3.global_position
	var attack_point_global_position = player_attack_point_global_position - global_position
	direction = attack_point_global_position
	direction_shoot = player.attack_point_2.global_position - global_position 
	if direction.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

func _physics_process(delta: float) -> void:
	if can_move:
		velocity = direction.normalized() * SPEED
		move_and_slide()

func on_emit_damage(target_hurt_box: Area2D) -> void:
	var current_direction = Vector2.LEFT if sprite_2d.flip_h == true else Vector2.RIGHT
	DamageReceiver.player_damage_receiver.emit(damage, current_direction)

func on_rececive_damage(target_hurt_box: Area2D, current_damage: int, current_direction: Vector2) -> void:
	if hurt_box == target_hurt_box:
		velocity = current_direction * KNOCKBACK_AMOUNT
		can_move = false
		move_and_slide()
		can_move = true
		current_health = clampi(current_health - (current_damage - DEF), 0, health)
		DamageManager.health_change.emit(self, current_health, health)
		if current_health <= health / 2 and DEF == 0:
			find_child("FiniteStateMachine").change_state("ArmcrBuff")
			DEF = 5
		if current_health == 0:
			find_child("FiniteStateMachine").change_state("Death")
			
		
