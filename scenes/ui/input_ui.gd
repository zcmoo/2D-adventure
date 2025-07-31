extends Control

const skill_pre = preload("res://scenes/ui/components/skill_button.tscn")

@onready var exit_btn = $exit
@onready var skill_list = $SkillButton

@onready var move_panel = $MovePanel
@onready var joy_panel = $"Virtual Joystick"

func _ready() -> void:
	Game.on_canvas_mode_changed.connect(self.on_canvas_mode_changed)
	Game.on_move_mode_changed.connect(self.on_move_mode_changed)
	
# 新增一个按钮
func addSkillButton(talent:Talent):
	var ins = skill_pre.instantiate()
	ins.position = Vector2.ZERO - size / 2
	ins.key_name = talent.name
	ins.image = talent.icon
	ins.bind_key = talent.bindKye
	skill_list.add_child(ins)
	Game.current_key = ins
	Game.key_map[talent.bindKye] = ins

func on_move_mode_changed(_mode):
	move_panel.visible = _mode == Game.MoveMode.NOR
	joy_panel.visible = _mode == Game.MoveMode.JOY

func on_canvas_mode_changed(_mode):
	if _mode == Game.CanvasMode.ADD:
		Game.game_ui.moveInputEnd()
		mouse_filter = MouseFilter.MOUSE_FILTER_STOP
		exit_btn.visible = true
	elif _mode == Game.CanvasMode.POSITION:
		mouse_filter = MouseFilter.MOUSE_FILTER_STOP
		Game.game_ui.moveInputEnd()
		exit_btn.visible = true
	else:
		mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
		Game.game_ui.moveInputStart()
		exit_btn.visible = false

func _on_exit_pressed() -> void:
	if Game.canvas_mode == Game.CanvasMode.ADD:
		Game.settings_ui.hide()
		Game.current_key = null
	Game.canvas_mode = Game.CanvasMode.NOR
