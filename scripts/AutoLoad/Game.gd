extends Node

#界面模式
enum CanvasMode {
	NOR,#默认模式
	POSITION, #移动布局模式
	ADD
}

#界面模式
enum MoveMode {
	NOR,#默认模式
	JOY, #摇杆模式
}

var player: Player # 全局玩家实例
var camera: GameCamera2D #全局相机实例
var move_mode = MoveMode.NOR :
	set(value):
		move_mode = value
		on_move_mode_changed.emit(move_mode)
		print(11)
var canvas_mode = CanvasMode.NOR :
	set(value):
		canvas_mode = value
		on_canvas_mode_changed.emit(canvas_mode)
var game_ui:CanvasLayer #顶级ui
var input_ui:Control # 按钮界面
var settings_ui:Control #设置界面
var current_key:Control # 当前选中Key
var frame_speed = 1.0 # 帧冻结速率
var key_map = {} # 映射按键字典

signal on_canvas_mode_changed(_canvas_mode)
signal on_move_mode_changed(_mode)

func _ready() -> void:
	if OS.get_name() != 'Windows':
		frame_speed = 1.5

# 帧冻结
func freeze_frame(freeze_duration: float):
	"""
	实现帧冻结，使用真实时间控制冻结效果。
	:param freeze_duration: 冻结时间（秒）。
	"""
	# 保存当前 time_scale
	var original_time_scale = Engine.time_scale
	# 设置 time_scale 为 0（冻结游戏逻辑）
	Engine.time_scale = 0.0
	
	# 使用实时计时来等待冻结结束
	var start_time = Time.get_ticks_msec()
	while Time.get_ticks_msec() < start_time + int(freeze_duration * 1000):
		await get_tree().physics_frame  # 等待下一帧
	
	# 恢复原始 time_scale
	Engine.time_scale = original_time_scale

# 帧冻结并逐渐恢复到原始速率
func time_scale_frame(freeze_duration: float, freeze_scale: float):
	"""
	实现帧冻结并逐渐恢复到原始速率，使用真实时间控制效果。
	:param freeze_duration: 冻结时间（秒）。
	:param freeze_scale: 冻结时的 time_scale 值。
	"""
	freeze_duration *= frame_speed
	freeze_scale *= frame_speed
	# 保存当前 time_scale
	var original_time_scale = Engine.time_scale
	# 设置 time_scale 为冻结值
	Engine.time_scale = freeze_scale

	# 使用实时计时等待冻结阶段结束
	var start_time = Time.get_ticks_msec()
	#while Time.get_ticks_msec() < start_time + int(freeze_duration * 1000):
	#	await get_tree().physics_frame  # 等待下一帧

	# 逐渐恢复到原始速率
	var recovery_start_time = Time.get_ticks_msec()
	while Time.get_ticks_msec() < recovery_start_time + int(freeze_duration * 1000):
		var elapsed = (Time.get_ticks_msec() - recovery_start_time) / (freeze_duration * 1000.0)
		# 线性插值 time_scale
		Engine.time_scale = lerp(freeze_scale, original_time_scale, elapsed)
		await get_tree().physics_frame  # 等待下一帧
	
	# 确保最终恢复为原始 time_scale
	Engine.time_scale = original_time_scale


func scale_frame(freeze_duration: float,time_scale:float):
	"""
	实现帧冻结，使用真实时间控制冻结效果。
	:param freeze_duration: 冻结时间（秒）。
	:param time_scale: 冻结速度（秒）。
	"""
	freeze_duration *= frame_speed
	time_scale *= frame_speed
	# 保存当前 time_scale
	var original_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	await get_tree().create_timer(freeze_duration * time_scale).timeout
	# 使用实时计时来等待冻结结束
	#var start_time = Time.get_ticks_msec()
	#while Time.get_ticks_msec() < start_time + int(freeze_duration * 1000):
	#	await get_tree().physics_frame  # 等待下一帧
	
	# 恢复原始 time_scale
	Engine.time_scale = original_time_scale

# 击退目标
func knockback(origin,target,knockback_strength,height = 0):
	var knockback_direction = (target.global_position - origin.global_position).normalized()
	var knockback_force = knockback_direction * knockback_strength
	if height != 0:
		knockback_force.y = height
	# 应用击退
	target.apply_knockback(knockback_force, 0.2)  # 持续 0.3 秒

#添加按键绑定
func addTalentButton(talent:Talent):
	if key_map.has(talent.bindKye):
		current_key = key_map[talent.bindKye]
	else:
		input_ui.addSkillButton(talent)
	canvas_mode = CanvasMode.ADD
