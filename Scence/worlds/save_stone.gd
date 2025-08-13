extends Interactable
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func interact() -> void:
	super.interact()
	animation_player.play("activated")
	SoundManager.play_sfx("LightUp")
	GameManager.save_game()
