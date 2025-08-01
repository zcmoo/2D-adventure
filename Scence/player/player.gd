class_name Player
extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
const JUMP_VELOCITY = -380.0
const RUN_SPEED = 160.0
const AIR_ACCELERARION = RUN_SPEED / 0.02
const FlOOR_ACCELERARION = RUN_SPEED / 0.2
enum State {MOVE, JUMP, FALL, Land}
var gravity = ProjectSettings.get("physics/2d/default_gravity") as float
var current_state: PlayerStateMachine = null
var state_factory: PlayerStateFactory = PlayerStateFactory.new()
var direction: float
var acceleration: float


func _ready() -> void:
	switch_state(State.FALL)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("跳跃"):
		jump_request_timer.start()
	if event.is_action_released("跳跃"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("向左移动","向右移动")
	acceleration = FlOOR_ACCELERARION if is_on_floor() else AIR_ACCELERARION
	set_heading()
	handle_move(delta)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, sprite_2d, animation_player, coyote_timer, jump_request_timer)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(State.keys()[state])
	call_deferred("add_child", current_state) 

func set_heading() -> void:
	if not is_zero_approx(direction):
		sprite_2d.flip_h = direction < 0

func handle_move(delta) -> void:
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()
