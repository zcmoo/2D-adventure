extends Node2D

@onready var px1 = $Parallax2D2
@onready var px2 = $Parallax2D3
@onready var px3 = $Parallax2D4
@onready var px4 = $Parallax2D5
@onready var px5 = $Parallax2D6
@onready var px6 = $Parallax2D7
@onready var px7 = $Parallax2D8
@onready var px9 = $Parallax2D10

func _ready() -> void:
	await get_parent().ready
	Game.player.on_player_move.connect(self.on_player_move)

func on_player_move(velocity:Vector2):
	if velocity.x != 0:
		px1.scroll_offset.x += velocity.x * 0.0001
		px2.scroll_offset.x += velocity.x * 0.0003
		px3.scroll_offset.x -= velocity.x * 0.0015
		px4.scroll_offset.x -= velocity.x * 0.003
		px5.scroll_offset.x -= velocity.x * 0.004
