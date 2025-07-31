extends Button

@export var talent:Talent ## 天赋
@onready var check = $Check
@onready var image = $Image
@onready var level = $Level

# 双击检测的时间间隔（毫秒）
const DOUBLE_CLICK_TIME_MS = 300
var last_click_time_ms = 0

func _ready() -> void:
	loadTalent()
	add_to_group("talent_group")
	startAnim()
	
	TalentUtils.on_talent_upgrade.connect(func upgrade(_talent):
		if talent.id == _talent.id:
			image.modulate = Color.WHITE
			level.text = "Lv%s" %_talent.current_level
		)

func loadTalent():
	if talent:
		level.text = ""
		image.texture = talent.icon
		image.modulate = Color('#2e2e2e')

func startAnim():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#tween.parallel().tween_property(self,"scale",Vector2(1,1),0.2).from(Vector2.ZERO)
	tween.parallel().tween_property(self,"position",position,0.3).from(Vector2(position.x,position.y + 15))
	tween.parallel().tween_property(self,"modulate:a",1.0,0.3).from(0.2)

func isSelect(_talent):
	check.visible = _talent == talent

func _on_pressed() -> void:
	TalentUtils.on_talent_click.emit(talent)
	get_tree().call_group("talent_group","isSelect",talent)

func _on_double_click():
	TalentUtils.upgradeTalent(talent)
	get_tree().call_group("talent_group","isSelect",talent)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var current_time_ms = Time.get_ticks_msec()
		if current_time_ms - last_click_time_ms <= DOUBLE_CLICK_TIME_MS:
			_on_double_click()
		last_click_time_ms = current_time_ms
