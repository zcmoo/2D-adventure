extends Node

enum Type {
	#无效果
	None,
	# 增加属性
	Attribute,
	# 主动触发技能
	Active
}

enum EffectsType {
	# 直接增加属性
	Attribute,
	# 效果加成
	EffectsAttribute
}

enum UseType {
	STR,#体力
	ANG #怒气
}

enum BuffType {
	# 正面
	Buffs,
	# 负面
	DeBuffs
}
