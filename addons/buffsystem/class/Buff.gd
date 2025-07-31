extends Resource
class_name Buff

@export var buff_name:String ## buff名称
@export var impact:BuffConsts.ImpactType ## buff影响 正面和负面影响
@export var stackable:bool ## 是否可叠加
@export var max_stacks:int ## buff最大层数
@export var tags :Array[String] ## buff 标签
@export var one_shoot:bool ## 是否为一次性BUFF
@export var time_out:float ## 循环周期，如果one_shoot为false，则会根据time_out进行循环执行
@export var priority:int ## 优先级，状态不可叠加，则会根据优先级，更高的优先级会替换掉。

var args = {} # buff携带参数

var current_stack:int #当前层数

func _init() -> void:
	print(123)
