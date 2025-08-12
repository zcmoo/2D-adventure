extends Interactable
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func interact() -> void:
	super.interact()
	animation_player.play("activated")
	GameManager.save_game()
