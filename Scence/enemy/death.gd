extends BossState
@onready var game_end_screen: Control = $"../../UI/GameEndScreen"


func enter():
	super.enter()
	animation_player.play("death")
	SoundManager.play_sfx("BossDie")
	await animation_player.animation_finished
	game_end_screen.show_game_over()
