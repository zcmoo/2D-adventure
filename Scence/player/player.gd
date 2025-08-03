class_name Player
extends CharacterBody2D
@export var can_combo: bool
@export var damage: int
@export var health: int
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var hand_checker: RayCast2D = $HandChecker
@onready var foot_checker: RayCast2D = $FootChecker
@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
const JUMP_VELOCITY = -380.0
const WALL_JUMP_VELOCITY = Vector2(400, -280)
const RUN_SPEED = 160.0
const AIR_ACCELERARION = RUN_SPEED / 0.1
const FlOOR_ACCELERARION = RUN_SPEED / 0.2
enum State {MOVE, JUMP, FALL, Land, SLIDE, WALL_JUMP, ATTACK_1, ATTACK_2, ATTACK_3}
var gravity = ProjectSettings.get("physics/2d/default_gravity") as float
var current_state: PlayerStateMachine = null
var state_factory: PlayerStateFactory = PlayerStateFactory.new()
var direction: float
var acceleration: float
var is_combo_requested = false


func _ready() -> void:
	switch_state(State.FALL)
	hit_box.area_entered.connect(on_emit_damage.bind())
	DamageReceiver.player_damage_receiver.connect(on_rececive_damage.bind())
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("跳跃"):
		jump_request_timer.start()
	if event.is_action_released("跳跃"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	if event.is_action_pressed("攻击") and can_combo:
		is_combo_requested = true

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("向左移动","向右移动")
	acceleration = FlOOR_ACCELERARION if is_on_floor() else AIR_ACCELERARION
	if current_state.should_fall() and not is_on_floor() and not is_on_wall():
		switch_state(Player.State.FALL)
	if current_state.can_handle_move():
		set_heading()
		handle_move(delta)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, sprite_2d, animation_player, coyote_timer, jump_request_timer, hand_checker, foot_checker)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(State.keys()[state])
	call_deferred("add_child", current_state) 

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

func handle_move(delta) -> void:
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta

func common_stand(delta) -> void:
	set_heading()
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta

func wall_stand(delta) -> void:
	sprite_2d.flip_h = (get_wall_normal().x == -1.0)
	hand_checker.scale.x = get_wall_normal().x
	foot_checker.scale.x = get_wall_normal().x
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func on_emit_damage(target_hurt_box: Area2D) -> void:
	var current_direction = Vector2.LEFT if sprite_2d.flip_h == true else Vector2.RIGHT
	DamageReceiver.enemy_damage_receiver.emit(target_hurt_box, damage, current_direction)

func on_rececive_damage(current_damage: int, current_direction: Vector2) -> void:
	health = clamp(health - current_damage, 0, health)

	
