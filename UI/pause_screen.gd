extends Control
@onready var resume: Button = $v/Actions/H/Resume


func	 _ready() -> void:
	hide()
	SoundManager.setup_ui_sounds(self)
	visibility_changed.connect(func ():
		get_tree().paused = visible
		)
	
func _on_resume_pressed() -> void:
	hide()

func _on_quit_pressed() -> void:
	GameManager.back_to_title()
	
func show_pause() -> void:
	show()
	resume.grab_focus()
