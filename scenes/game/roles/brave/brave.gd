extends Player

var shield_hp = 100 # 盾牌耐久
@onready var shiled_ui = $ShieldHp

func _ready() -> void:
	super._ready()
	PlayerData.on_player_death.connect(self.on_player_death)

func on_player_death():
	state_machine.change_state("Death")

func changeShieldHp(value):
	shield_hp += value
	if shield_hp > 100:
		shield_hp = 100
	shiled_ui.value = shield_hp
