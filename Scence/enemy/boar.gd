class_name Boar
extends Enemy
@onready var boar_wall_checker: RayCast2D = $Graphics/WallChecker
@onready var boar_floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var boar_player_checker: RayCast2D = $Graphics/PlayerChecker
enum State {IDLE, WALK, RUN, HURT, DIE}
const KNOCKBACK_AMOUNT = 300


func _ready() -> void:
	super._ready()
	switch_state(State.WALK)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if health == 0 and not is_dead:
		switch_state(State.DIE)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_boar_state(state)
	current_state.setup_boar(self, animation_player, boar_wall_checker, boar_floor_checker, boar_player_checker, hit_box, hurt_box)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BoarState" + str(State.keys()[state])
	call_deferred("add_child", current_state) 

func on_rececive_damage(target_hurt_box: Area2D, current_damage: int, current_direction: Vector2) -> void:
	super.on_rececive_damage(target_hurt_box, current_damage, current_direction)
	if not is_hurting and not is_dead and hurt_box == target_hurt_box:
		velocity = current_direction * KNOCKBACK_AMOUNT
		switch_state(State.HURT)

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()
