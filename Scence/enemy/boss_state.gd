class_name BossState
extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var boss_debug: Label = %BossDebug
@onready var player = owner.player


func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func transition():
	pass	

func _physics_process(_delta: float) -> void:
	transition()
	boss_debug.text = name
