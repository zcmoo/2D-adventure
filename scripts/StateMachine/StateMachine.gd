# StateMachine.gd
extends Node

# 状态机
class_name StateMachine

# 状态字典
var states = {}
var current_state: State
var player:Player

func _ready() -> void:
	player = get_parent()
	for state in get_children():
		add_state(state.name,state)

# 添加状态
func add_state(state_name: String, state: State):
	states[state_name] = state
	state.init(self,player)

func get_state(state_name: String) -> State:
	return states[state_name]

# 切换状态
func change_state(state_name: String, params = {}):
	var pre_state = states.get(state_name)
	if not pre_state.preMethod():
		return
	if current_state:
		current_state.exit()
	current_state = pre_state
	if current_state:
		current_state.enter(params)
	else:
		print("State not found: ", state_name)

# 更新当前状态
func update(delta):
	if current_state:
		current_state.update(delta)

func atkInputEvent():
	if Input.is_action_just_pressed("atk"):
		self.change_state("Atk",{'state':'Idle'})
	
	#if InputBuffer.is_action_press_buffered("heal"):
	#	self.change_state("Heal")
	
	if Input.is_action_pressed("heal"):
		self.change_state("Heal")
		return
	
	if Input.is_action_pressed("heal_slash"):
		self.change_state("HealSlash")
		return
		
	if Input.is_action_pressed("light_cut"):
		self.change_state("LightCut")
		return
	
	if Input.is_action_pressed("saint_heal"):
		self.change_state("SaintHeal")
		return
	
	if Input.is_action_just_pressed("shield_buff"):
		self.change_state("ShieldBuff")
		return
	
	if Input.is_action_just_pressed("sword_buff"):
		self.change_state("SwordBuff")
		return
