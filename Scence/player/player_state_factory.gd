class_name PlayerStateFactory
var states: Dictionary


func _init() -> void:
	states = {
		Player.State.MOVE: PlayerStateMove,
		Player.State.JUMP: PlayerStateJump,
		Player.State.FALL: PlayerStateFall,
		Player.State.Land: PlayerStateLand,
		Player.State.SLIDE: PlayerStateSlide,
		Player.State.WALL_JUMP: PlayerWallJUMP,
		Player.State.ATTACK_1: PlayerStateAttack_1,
		Player.State.ATTACK_2: PlayerStateAttack_2,
		Player.State.ATTACK_3: PlayerStateAttack_3,
		Player.State.HURT: PlayerStateHurt,
		Player.State.DIE: PlayerStateDie,
		Player.State.SLID_START: PlayerStateSlideStart,
		Player.State.SLID_LOOP: PlayerStateSlideLOOP,
		Player.State.SLID_END: PlayerStateSlideEnd,
	}

func get_fresh_state(state: Player.State) -> PlayerStateMachine:
	assert(states.has(state), "state don't exist!")
	return states.get(state).new()
	
