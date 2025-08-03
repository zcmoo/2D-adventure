class_name Boar
extends Enemy
@onready var boar_wall_checker: RayCast2D = $Graphics/WallChecker
@onready var boar_floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var boar_player_checker: RayCast2D = $Graphics/PlayerChecker
enum State {IDLE, WALK, RUN}


func _ready() -> void:
	switch_state(State.WALK)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_boar_state(state)
	current_state.setup_boar(self, animation_player, boar_wall_checker, boar_floor_checker, boar_player_checker)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BoarState" + str(State.keys()[state])
	call_deferred("add_child", current_state) 
