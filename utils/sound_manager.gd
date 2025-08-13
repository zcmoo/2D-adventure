extends Node
@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer


func play_sfx(name: String) -> void:
	var player = sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	player.play()

func player_bgm(stream: AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()
