extends Node
## buff管理工具

var _buff_list = {} ## buff合集

signal on_buff_add(_buff:Buff)
signal on_buff_remove(_buff:Buff)
signal on_stacks_changed(_buff:Buff)

# 新增一个BUFF
func add_buff(_buff:Buff):
	if _buff_list.has(_buff.buff_name):
		var buff = _buff_list[_buff.buff_name] as Buff
		if _buff.stackable && _buff.current_stack < _buff.max_stacks: ## 层数叠加
			buff.current_stack += 1
			on_stacks_changed.emit(buff)
		
		if _buff.stackable == false && _buff.priority > buff.priority: ## 优先级替换
			remove_buff(buff)
			add_buff(_buff)
	else:
		_buff_list[_buff.buff_name] = _buff
		on_buff_add.emit(_buff)

# 移除 Buff
func remove_buff(buff_name: String):
	on_buff_remove.emit(_buff_list[buff_name])
	_buff_list.erase(buff_name)
