extends Node

@export var max_hp = 100 ## 最大生命值
@export var current_hp = 0 ## 当前生命值
@export var max_strength = 99900 ## 最大体力值
@export var current_strength = 99900 ## 当前体力值
@export var anger = 999 ## 怒气
@export var max_anger = 999 ## 怒气

var is_death = false ## 是否死亡

var atk_buff_temp = 0.0 #一次性攻击加成
@export var player_atk = 100 # 玩家基础攻击力
@export var player_def = 0.0 # 玩家免伤

# 血量改变触发
signal on_hp_changed(current,max)

# 体力改变触发
signal on_strength_changed(current,max)

# 怒气改变触发
signal on_anger_changed(current)

# 角色死亡
signal on_player_death()

# 获取玩家伤害
func getDamage():
	if atk_buff_temp > 0:
		var new_atk = player_atk * (1 + atk_buff_temp / 100.0)
		atk_buff_temp = 0
		return roundi(new_atk)
	return roundi(player_atk)

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 25 == 0:
		useStrength(1)

# 回血
func health(_hp):
	if is_death:
		return
	EffectUtils.show_floating_text("+%s" %_hp,Game.player.global_position + Vector2(0,-30),{'color':'#87ea6b'})
	
	current_hp += _hp
	if current_hp > max_hp:
		current_hp = max_hp
	on_hp_changed.emit(current_hp,max_hp)

# 减少或增加血量
func useHp(value):
	if is_death:
		return
	current_hp += value
	if current_hp <= 0:
		is_death = true
		on_player_death.emit()
	on_hp_changed.emit(current_hp,max_hp)

# 减少或增加体力
func useStrength(value) -> bool:
	if value < 0:
		if current_strength >= abs(value):
			current_strength += value
			on_strength_changed.emit(current_strength,max_strength)
			return true
		else:
			MessageBox.alert("体力不足！")
			return false
	else:
		if current_strength + value > max_strength:
			current_strength = max_strength
		else:
			current_strength += value
		on_strength_changed.emit(current_strength,max_strength)
		return true

# 增加怒气
func useAnger(value):
	if value < 0:
		if anger >= abs(value):
			anger += value
			on_anger_changed.emit(anger)
			return true
		else:
			return false
	else:
		if anger + value > max_anger:
			anger = max_anger
		else:
			anger += value
		on_anger_changed.emit(anger)

# 使用对应能量
func useMp(talent:Talent):
	if talent.useType == Consts.UseType.STR:
		return useStrength(-talent.strength)
	elif talent.useType == Consts.UseType.ANG:
		return useAnger(-talent.strength)
