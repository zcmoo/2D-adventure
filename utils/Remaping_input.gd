extends Control
@onready var remapable_btns_container: VBoxContainer = $RemapableBtnsContainer
@onready var remapable_btns_container_3: VBoxContainer = $RemapableBtnsContainer3
@export var remapable_inputs: Array[String] = ["向左移动", "向右移动", "跳跃", "暂停"]
@export var remapable_inputs2: Array[String] = ["攻击", "滑铲", "交互"]
var save_path = "user://my_remap.cfg"
var defult_map_cfg_path = "user://my_defult_remap.cfg"
var remapping_action = ""
var remapping = false


func _ready() -> void:
	await save_input_map_cfg(true)
	load_remap_cfg(false)
	_init_remap_btns()
	show_now_actions()
	SoundManager.setup_ui_sounds(self)

func _init_remap_btns():
	for i in remapable_inputs:
		var p_btn = Button.new()
		remapable_btns_container.add_child(p_btn)
		p_btn.name = i
		p_btn.button_down.connect(_on_remap_button_down.bind(p_btn))
	for j in remapable_inputs2:
		var p_btn = Button.new()
		remapable_btns_container_3.add_child(p_btn)
		p_btn.name = j
		p_btn.button_down.connect(_on_remap_button_down.bind(p_btn))

func _on_remap_button_down(p_from:Button):
	remapping = true
	remapping_action = p_from.name

func _input(event):
	if (event is InputEventMouse) or (event is InputEventMouseButton):
		return
	if remapping:
		for i in InputMap.get_actions():
			if i == remapping_action:
				var p_events = InputMap.action_get_events(i)
				p_events[0] = event
				InputMap.action_erase_events(i)
				for j in p_events:
					InputMap.action_add_event(i,j)
		remapping = false
		show_now_actions()
		save_input_map_cfg(false)

func show_now_actions():
	if remapping == false and is_node_ready():
		for i in remapable_btns_container.get_children():
			if InputMap.action_get_events(i.name).size()>0:
				i.text = InputMap.action_get_events(i.name)[0].as_text()
		for j in remapable_btns_container_3.get_children():
			if InputMap.action_get_events(j.name).size()>0:
				j.text = InputMap.action_get_events(j.name)[0].as_text()

func save_input_map_cfg(save_defult_cfg:bool):
	var p_path = ""
	if save_defult_cfg:
		p_path = defult_map_cfg_path
	else :
		p_path = save_path
	var p_cfg = ConfigFile.new()
	for i in InputMap.get_actions():
		var p_events = InputMap.action_get_events(i)
		p_cfg.set_value("data", i, p_events)
	return p_cfg.save(p_path)

func load_remap_cfg(load_to_reset:bool):
	var p_path = ""
	if load_to_reset:
		p_path = defult_map_cfg_path
	else :
		p_path = save_path
	var p_cfg = ConfigFile.new()
	var err = p_cfg.load(p_path)
	if err != OK:
		return
	for i in InputMap.get_actions():
		var p_events = p_cfg.get_value("data",i)
		InputMap.action_erase_events(i)
		for p_event in p_events:
			InputMap.action_add_event(i,p_event)

func _on_reset_button_up() -> void:
	GameManager.back_to_title()
