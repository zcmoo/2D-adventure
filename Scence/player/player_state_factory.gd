class_name PlayerStateFactory
var states: Dictionary


func _init() -> void:
	states = {
		Player.State.MOVE: PlayerStateMove,
		Player.State.JUMP: PlayerStateJump,
		Player.State.FALL: PlayerStateFall,
		Player.State.Land: PlayerStateLand,
	}

func get_fresh_state(state: Player.State) -> PlayerStateMachine:
	assert(states.has(state), "state don't exist!")
	return states.get(state).new()
	
