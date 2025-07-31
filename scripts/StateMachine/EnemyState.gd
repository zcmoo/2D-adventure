# EnemyState.gd
extends Node

# 状态基类
class_name EnemyState

# 引用状态机
var state_machine: EnemyStateMachine
var player: Enemy

# 初始化状态
func init(_state_machine,_player:Enemy):
	state_machine = _state_machine
	player = _player

# 状态生命周期
func enter(params = {}):
	pass

func update(delta):
	pass

func exit():
	pass
