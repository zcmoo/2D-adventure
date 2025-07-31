extends Button

@export var bind_key = ""
@export var key_name:String
@export var image :Texture
@onready var current = $Current
@onready var texture_rect = $TextureRect
@onready var label = $Label

@onready var animPlayer = $AnimationPlayer

var dragging = false

func _ready() -> void:
	modulate.a = 0.8
	if image:
		texture_rect.texture = image
	if key_name:
		label.text = key_name
	Game.on_canvas_mode_changed.connect(self.on_canvas_mode_changed)
	var pos = ConfigUtils.getKeyPosition(bind_key)
	if pos:
		position = pos

func on_canvas_mode_changed(_mode):
	current.visible = false
	animPlayer.stop()
	if _mode == Game.CanvasMode.NOR:
		modulate.a = 0.8
	else:
		if _mode == Game.CanvasMode.ADD && Game.current_key == self:
			current.visible = true
			animPlayer.play('add')
		modulate.a = 1

func _on_gui_input(event: InputEvent) -> void:
	if Game.canvas_mode == Game.CanvasMode.NOR:
		if event is InputEventScreenTouch:
			if event.is_pressed():
				Input.action_press(bind_key)
				scale = Vector2(0.9,0.9)
			else:
				Input.action_release(bind_key)
				scale = Vector2(1,1)
	elif Game.canvas_mode == Game.CanvasMode.POSITION || Game.current_key == self:
		if event is InputEventMouseButton and event.pressed or event is InputEventScreenTouch and event.pressed:
			dragging = true

		elif (event is InputEventMouseMotion and dragging) or (event is InputEventScreenDrag and dragging):
			var new_position = position + event.relative * 0.5
			position = new_position
			
		elif event is InputEventMouseButton and not event.pressed or event is InputEventScreenTouch and not event.pressed:
			dragging = false
			ConfigUtils.setKeyPosition(bind_key,position)
