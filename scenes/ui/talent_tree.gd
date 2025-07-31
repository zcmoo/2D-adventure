extends Control

@onready var talent_panel = $TalentPanel

# 缩放参数
var zoom: float = 1.0
var min_zoom: float = 0.5
var max_zoom: float = 1.0

# 拖动参数
var touch_move: bool = false
var is_dragging: bool = false
var last_mouse_position: Vector2
var velocity: Vector2 = Vector2.ZERO  # 拖动速度

# 平滑参数
var friction: float = 15  # 惯性阻力
var move_speed: float = 25.0  # 偏移平滑速度
var target_offset: Vector2 = Vector2.ZERO  # 目标偏移量
var current_offset: Vector2 = Vector2.ZERO  # 当前偏移量

# 存储触摸点
var touch_points: Dictionary = {}

# 缩放
var target_zoom: float = 1.0

func _ready():
	talent_panel.scale *= target_zoom
	set_process(false)
	center_panel()
	target_offset = talent_panel.position
	current_offset = target_offset
	target_zoom = zoom
	

func center_panel():
	var viewport_center = size / 2  # 视口中心
	var panel_size = talent_panel.size * target_zoom               # 缩放后 Panel 大小
	talent_panel.position = viewport_center - panel_size / 2    

# 缩放画布
func zoom_canvas(factor: float, mouse_pos: Vector2):
	# 获取当前的缩放位置
	var panel_size = talent_panel.size * talent_panel.scale
	var panel_center = talent_panel.position + panel_size / 2

	# 计算缩放前的偏移
	var offset = mouse_pos - panel_center

	# 更新目标缩放值并限制范围
	target_zoom = clamp(target_zoom * factor, min_zoom, max_zoom)

	# 计算新的缩放后中心
	var new_panel_size = talent_panel.size * target_zoom
	var new_panel_center = mouse_pos - offset

	# 通过缩放后的中心位置调整 Panel 的位置
	talent_panel.scale = Vector2(target_zoom, target_zoom)
	talent_panel.position = new_panel_center - new_panel_size / 2

# 更新每帧逻辑
func _process(delta):
	# 插值缩放
	zoom = lerp(zoom, target_zoom, move_speed * delta)
	talent_panel.scale = Vector2(zoom, zoom)

	# 如果不在拖动，处理惯性
	if not is_dragging:
		target_offset += velocity * delta
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)  # 阻力减速

	# 更新偏移
	current_offset = current_offset.lerp(target_offset, move_speed * delta)
	talent_panel.position = current_offset
	
	if velocity.length() < 0.1 && !is_dragging && touch_move:
		touch_move = false
		velocity = Vector2.ZERO
		set_process(false)
		return


func _on_gui_input(event: InputEvent) -> void:
	if not get_parent().get_parent().visible:
		return
	# 缩放
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom_canvas(1.1,get_global_mouse_position())
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_canvas(0.9,get_global_mouse_position())

	# 拖动
	elif event is InputEventMouseMotion or event is InputEventScreenDrag:
		if is_dragging:
			velocity = event.relative * 0.5  # 实时记录速度
			target_offset += event.relative * 0.5

	# 检测鼠标按下和释放
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		if is_dragging:
			velocity = Vector2.ZERO  # 开始拖动时清空速度
			set_process(true)
		touch_move = event.pressed
