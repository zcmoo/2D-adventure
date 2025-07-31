extends Node

# 武器命中效果
const sword_effect_pre = preload("res://scenes/game/effect/sword_hit/SwordHitEffect.tscn")
#残影
const trail_scene = preload("res://scenes/game/effect/DashTrail.tscn")
#飘字
const floating_text_scene = preload("res://scenes/ui/components/FloatingText.tscn")
#疾跑重击
const sprint_atk_pre = preload("res://scenes/game/effect/sword_hit/SprintAtkEffect.tscn")

var effect_nodes :Node2D

# 添加命中特效
func addSwordEffect(_position:Vector2):
	var ins = sword_effect_pre.instantiate()
	ins.setEffectPosition(_position)
	effect_nodes.add_child(ins)

# 添加疾跑重击
func addSprintAtkEffect(_position:Vector2):
	var ins = sprint_atk_pre.instantiate()
	ins.setEffectPosition(_position)
	effect_nodes.add_child(ins)

# 创建残影
func create_trail(param = {}):
	var trail = trail_scene.instantiate()
	trail.texture = param['texture']
	trail.global_position = param['global_position']
	trail.global_transform.x.x = param['transform']
	trail.offset = param['offset']
	effect_nodes.add_child(trail)  # 将残影加入到场景中

# 创建飘字
func show_floating_text(text: String, position: Vector2,param = null):
	
	position.x = randi_range(position.x-10,position.x + 10)
	position.y -= 40
	var floating_text = floating_text_scene.instantiate()
	floating_text.global_position = position  # 设置飘字位置
	floating_text.get_node("Label").text = text  # 设置显示的文字
	effect_nodes.add_child(floating_text)
	
	if param:
		if param.has('color'):
			floating_text.get_node("Label").set('theme_override_colors/font_color',param['color'])
