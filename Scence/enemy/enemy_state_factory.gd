class_name EnemyStateFactory
var boar_states: Dictionary


func _init() -> void:
	boar_states = {
		Boar.State.IDLE: BoarStateIDLE,
		Boar.State.WALK: BoarStateWalk,
		Boar.State.RUN: BoarStateRun,
		Boar.State.HURT: BoarStateHurt,
		Boar.State.DIE: BoarStateDie
	}

func get_fresh_boar_state(state: Boar.State) -> EnemyStateMachine:
	assert(boar_states.has(state), "state don't exist!")
	return boar_states.get(state).new()
	
