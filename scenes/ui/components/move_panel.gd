extends Panel

@onready var action_button = $Button

var dragging: bool = false
var last_direction: int = 0 # -1 表示左，1 表示右，0 表示无方向
var center: Vector2 # 中心点（初始按钮位置）
var drag_speed_scale: float = 0.5 # 控制移动速度

func _ready() -> void:
	modulate.a = 0.8
	center = action_button.position # 设定按钮初始位置为中心点
	Game.on_canvas_mode_changed.connect(self.on_canvas_mode_changed)

	var pos = ConfigUtils.getKeyPosition('move')
	if pos:
		position = pos


func on_canvas_mode_changed(_mode):
	if _mode == Game.CanvasMode.NOR:
		modulate.a = 0.8
	else:
		modulate.a = 1

func _on_button_gui_input(event: InputEvent) -> void:
	if Game.canvas_mode == Game.CanvasMode.NOR:
		if event is InputEventMouseButton and event.pressed or event is InputEventScreenTouch and event.pressed:
			dragging = true

		elif (event is InputEventMouseMotion and dragging) or (event is InputEventScreenDrag and dragging):
			# 更新按钮位置
			var new_x = action_button.position.x + event.relative.x * drag_speed_scale
			var min_x = 0
			var max_x = size.x - action_button.size.x
			action_button.position.x = clamp(new_x, min_x, max_x)

			# 检测是否越过中心点
			if action_button.position.x < center.x: # 向左越过中心点
				if last_direction != -1:
					simulate_key_press("move_left", "move_right")
					last_direction = -1
			elif action_button.position.x > center.x: # 向右越过中心点
				if last_direction != 1:
					simulate_key_press("move_right", "move_left")
					last_direction = 1

		elif event is InputEventMouseButton and not event.pressed or event is InputEventScreenTouch and not event.pressed:
			dragging = false
			simulate_key_release("move_left", "move_right")
			last_direction = 0
			action_button.position = center
	elif Game.canvas_mode == Game.CanvasMode.POSITION:
		if event is InputEventMouseButton and event.pressed or event is InputEventScreenTouch and event.pressed:
			dragging = true

		elif (event is InputEventMouseMotion and dragging) or (event is InputEventScreenDrag and dragging):
			var new_position = position + event.relative * 0.5
			position = new_position
			
		elif event is InputEventMouseButton and not event.pressed or event is InputEventScreenTouch and not event.pressed:
			dragging = false
			ConfigUtils.setKeyPosition('move',position)

func simulate_key_press(press_action: String, release_action: String) -> void:
	if not Input.is_action_pressed(press_action):
		Input.action_release(release_action)
		Input.action_press(press_action)

func simulate_key_release(action_1: String, action_2: String) -> void:
	if Input.is_action_pressed(action_1):
		Input.action_release(action_1)
	if Input.is_action_pressed(action_2):
		Input.action_release(action_2)
