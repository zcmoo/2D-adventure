class_name Player
extends CharacterBody2D
@export var can_combo: bool
@export var damage: int
@export var health: int
@export var energy: float
@export var energy_regen: float
@onready var coyote_timer: Timer = $Timer/CoyoteTimer
@onready var jump_request_timer: Timer = $Timer/JumpRequestTimer
@onready var invincible_timer: Timer = $Timer/InvincibleTimer
@onready var attack_request_timer: Timer = $Timer/AttackRequestTimer
@onready var slide_request_timer: Timer = $Timer/SlideRequestTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand_checker: RayCast2D = $HandChecker
@onready var foot_checker: RayCast2D = $FootChecker
@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_shape: CollisionShape2D = $HitBox/AttackShape
@onready var interation_icon: AnimatedSprite2D = $InterationIcon
@onready var player_debug: Label = %PlayerDebug
@onready var attack_point: Marker2D = $attack_points/attack_point
@onready var attack_point_2: Marker2D = $attack_points/attack_point2
@onready var attack_point_3: Marker2D = $attack_points/attack_point3
@onready var fps: Label = %Fps
@onready var game_over_sreen: Control = $UI/GameOverSreen
const JUMP_VELOCITY = -380.0
const WALL_JUMP_VELOCITY = Vector2(400, -280)
const RUN_SPEED = 160.0
const AIR_ACCELERARION = RUN_SPEED / 0.1
const FlOOR_ACCELERARION = RUN_SPEED / 0.2
const KNOCKBACK_AMOUNT = 500.0
const SLIDE_SPEED = 180.0
const LANDING_HEIGHT = 80.0
const DAMMAGE_HEIGHT = 120.0
const HEIGHT_DAMMAGE = 20
const SLIDE_ENERGY = 30.0
enum State {MOVE, JUMP, FALL, Land, SLIDE, WALL_JUMP, ATTACK_1, ATTACK_2, ATTACK_3, HURT, DIE, SLID_START, SLID_LOOP, SLID_END}
enum Direction {LEFT = -1, RIGHT = +1}
var gravity = ProjectSettings.get("physics/2d/default_gravity") as float
var current_state: PlayerStateMachine = null
var state_factory: PlayerStateFactory = PlayerStateFactory.new()
var direction: float
var acceleration: float
var is_combo_requested = false
var hurt_direction: Vector2
var is_hurting: bool
var is_dead: bool
var is_fall: bool
var current_health: int
var current_energy: float
var fall_from_y: float
var interacting_with: Array[Interactable]   


func _init() -> void:
	DamageReceiver.player_damage_receiver.connect(on_rececive_damage.bind())
	EnergyManager.energy_change.emit(current_energy, energy)

func _ready() -> void:
	add_to_group("player")
	current_health = health
	current_energy = energy
	switch_state(State.FALL)
	hurt_box.monitorable = true	
	hit_box.monitoring = false
	hit_box.area_entered.connect(on_emit_damage.bind())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("跳跃"):
		jump_request_timer.start()
	if event.is_action_released("跳跃"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	if event.is_action_pressed("攻击") :
		attack_request_timer.start()	
	if event.is_action_released("攻击"):
		attack_request_timer.stop()
	if event.is_action_pressed("滑铲"):
		slide_request_timer.start()
	if event.is_action_released("滑铲"):
		slide_request_timer.stop()
	if attack_request_timer.time_left > 0 and can_combo:
		is_combo_requested = true
	if event.is_action_pressed("交互") and interacting_with:
		interacting_with.back().interact()

func _physics_process(delta: float) -> void:
	fps.text = "Fps = " + str(Engine.get_frames_per_second())
	energy_revive(delta)
	interation_icon.visible = not interacting_with.is_empty()
	direction = Input.get_axis("向左移动","向右移动")
	acceleration = FlOOR_ACCELERARION if is_on_floor() else AIR_ACCELERARION
	if not is_fall and current_state.should_fall() and not is_on_floor() and not is_on_wall(): 
		switch_state(Player.State.FALL)
	if current_state.can_handle_move():
		handle_move(delta)
	if invincible_timer.time_left > 0:
		sprite_2d.modulate.a = sin(Time.get_ticks_msec() / 20) * 0.5 + 0.5
	else:
		sprite_2d.modulate.a = 1

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, sprite_2d, animation_player, coyote_timer, jump_request_timer, hand_checker, foot_checker, hit_box, hurt_box, invincible_timer, attack_request_timer, slide_request_timer, game_over_sreen)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(State.keys()[state])
	player_debug.text = current_state.name
	call_deferred("add_child", current_state) 

func energy_revive(delta) -> void:
	current_energy = clampf(current_energy + energy_regen * delta, 0.0, energy)
	EnergyManager.energy_change.emit(current_energy, energy)

func register_interactable(v: Interactable) -> void:
	if is_dead:
		return
	if v in interacting_with:
		return
	interacting_with.append(v)

func unregister_interactable(v: Interactable) -> void:
	interacting_with.erase(v)

func set_heading() -> void:
	if not is_zero_approx(direction):
		if direction < 0:
			sprite_2d.flip_h = true
			hand_checker.scale.x = -1
			foot_checker.scale.x = -1
			hit_box.scale.x = 1
			hurt_box.scale.x = 1
		else:
			sprite_2d.flip_h = false
			hand_checker.scale.x = 1
			foot_checker.scale.x = 1
			hit_box.scale.x = -1
			hurt_box.scale.x = -1

func set_entry_heading(heading: int) -> void:
	if heading < 0:
		sprite_2d.flip_h = true
		hand_checker.scale.x = -1
		foot_checker.scale.x = -1
		hit_box.scale.x = 1
		hurt_box.scale.x = 1
	else:
		sprite_2d.flip_h = false
		hand_checker.scale.x = 1
		foot_checker.scale.x = 1
		hit_box.scale.x = -1
		hurt_box.scale.x = -1

func set_wall_slide_heading() -> void:
	sprite_2d.flip_h = (get_wall_normal().x == -1.0)
	hand_checker.scale.x = get_wall_normal().x
	foot_checker.scale.x = get_wall_normal().x

func handle_move(delta) -> void:
	set_heading()
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta

func slide(delta) -> void:
	set_heading()
	velocity.x = move_toward(velocity.x, hand_checker.scale.x * SLIDE_SPEED, acceleration * delta)
	velocity.y += gravity * delta

func common_stand(delta) -> void:
	set_heading()
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta

func wall_stand(delta) -> void:
	set_wall_slide_heading()
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta

func dead_move(delta) -> void:
	velocity.x = hurt_direction.x * KNOCKBACK_AMOUNT
	velocity.y += gravity * delta

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func on_emit_damage(target_hurt_box: Area2D) -> void:
	var current_direction = Vector2.LEFT if sprite_2d.flip_h == true else Vector2.RIGHT
	DamageReceiver.enemy_damage_receiver.emit(target_hurt_box, damage, current_direction)
	SoundManager.play_sfx("Hit")
	GameManager.shake_camera(2)
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.05, true, false, true).timeout
	Engine.time_scale = 1

func on_rececive_damage(current_damage: int, current_direction: Vector2) -> void:
	if invincible_timer.time_left > 0:
		return
	hurt_direction = current_direction
	current_health = clampi(current_health - current_damage, 0, health)
	DamageManager.health_change.emit(self, current_health, health)
	SoundManager.play_sfx("Hurt")
	GameManager.shake_camera(5)
	if current_health > 0 and not is_hurting:
		switch_state(State.HURT)
	elif current_health == 0:
		switch_state(State.DIE)
