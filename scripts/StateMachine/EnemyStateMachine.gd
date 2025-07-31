# EnemyStateMachine.gd
extends Node

# 状态机
class_name EnemyStateMachine

# 状态字典
var states = {}
var current_state: EnemyState
var player:Enemy

func _ready() -> void:
	player = get_parent()
	for state in get_children():
		add_state(state.name,state)

# 添加状态
func add_state(state_name: String, state: EnemyState):
	states[state_name] = state
	state.init(self,player)

# 切换状态
func change_state(state_name: String, params = {}):
	if current_state:
		current_state.exit()
	current_state = states.get(state_name)
	if current_state:
		current_state.enter(params)
	else:
		print("State not found: ", state_name)

# 更新当前状态
func update(delta):
	if current_state:
		current_state.update(delta)
