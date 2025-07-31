extends Node2D

@onready var effect_nodes = $EffectNodes

func _ready() -> void:
	EffectUtils.effect_nodes = effect_nodes
