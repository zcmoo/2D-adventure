extends Control

@onready var _name = $Name
@onready var _level = $Level
@onready var image = $TextureRect
@onready var _info = $Info
@onready var upgrade = $Upgrade
@onready var _pre = $Pre
@onready var _str = $Str
@onready var _key = $key
var current_talent

func _ready() -> void:
	TalentUtils.on_talent_click.connect(self.on_talent_click)
	TalentUtils.on_talent_upgrade.connect(self.on_talent_click)

func on_talent_click(talent:Talent):
	current_talent = talent
	_name.text = talent.name
	if talent.current_level == 0:
		_level.text =  '尚未学习'
		image.modulate = Color('#2e2e2e')
	else:
		_level.text = "Lv.%s" %talent.current_level
		image.modulate = Color.WHITE
	image.texture = talent.icon
	if talent.useType == Consts.UseType.STR:
		_str.set("theme_override_colors/font_color","#d682eb")
		_str.text = "消耗体力：%s" %talent.strength
	else:
		_str.set("theme_override_colors/font_color","#df9563")
		_str.text = "消耗怒气：%s" %talent.strength
	_info.text = talent.get_dynamic_description()
	
	_key.visible = talent.type == Consts.Type.Active
	
	if Game.key_map.has(talent.bindKye):
		_key.text = "已设置"
	else:
		_key.text = "未设置按键"
	
	if talent.prerequisites:
		_pre.text = '需要天赋：'
		var index = 0 
		for t in talent.prerequisites:
			if index > 0:
				_pre.text += " | "
			_pre.text += t.name
			index += 1
	else:
		_pre.text = '需要天赋：无'

# 升级天赋
func _on_upgrade_pressed() -> void:
	if current_talent:
		var code = TalentUtils.upgradeTalent(current_talent)

func _on_key_pressed() -> void:
	if TalentUtils.getTalent(current_talent.id):
		Game.addTalentButton(current_talent)
	else:
		MessageBox.alert("请先学习天赋后再配置按键！")
