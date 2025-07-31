extends Control

@onready var hp_anim_bar = $bg/TextureRect2/Control/AnimatedSprite2D
@onready var hp_bar = $bg/TextureRect2
@onready var bar_start = $bg/TextureRect

@onready var hp_label_curr = $Label
@onready var hp_label_max = $Label/Label2/Label3

@onready var str_bar = $TextureRect/TextureProgressBar ## 体力条
@onready var str_label = $Label2
@onready var str_max_label = $Label2/Label2/Label3

@onready var ang_bar = $TextureRect2/TextureProgressBar ## 怒气条
@onready var ang_label = $Label3

const max_hp_width = 145

var max_hp = 0
var curr_hp = 0

func _ready() -> void:
	PlayerData.on_anger_changed.connect(self.on_anger_changed)
	PlayerData.on_hp_changed.connect(self.on_hp_changed)
	PlayerData.on_strength_changed.connect(self.on_strength_changed)

func on_strength_changed(current,max):
	str_bar.max_value = max
	str_bar.value = current
	str_max_label.text = str(max)
	str_label.text = str(current)

func on_anger_changed(anger:int):
	ang_bar.value = anger
	ang_label.text = str(anger)

func on_hp_changed(curr_hp,max_hp):
	if max_hp == curr_hp:
		hp_anim_bar.play("max")
	elif curr_hp <= 0:
		hp_anim_bar.play("min")
	else:
		hp_anim_bar.play("down")
	var width_r = float(curr_hp) / max_hp
	get_tree().create_tween().tween_property(hp_bar,"size:x",max_hp_width * width_r,0.1)
	hp_label_curr.text = str(curr_hp)
	hp_label_max.text = str(max_hp)

func _on_timer_timeout() -> void:
	pass

func onHpHit():
	var tween = create_tween()
	tween.tween_property($bg,"position",$bg.position,0.2).from(Vector2(80,40))
