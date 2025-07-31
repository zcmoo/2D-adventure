# State.gd
extends Node

# 状态基类
class_name State

# 引用状态机
var state_machine: StateMachine
var player: Player

# 初始化状态
func init(_state_machine,_player:Player):
	state_machine = _state_machine
	player = _player

# 状态生命周期
func enter(params = {}):
	pass

func update(delta):
	pass

func exit():
	pass

# 前置条件
func preMethod() -> bool:
	return true
