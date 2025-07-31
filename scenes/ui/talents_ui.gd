extends Control

@onready var talent_panel = $Panel/TalentTree/TalentPanel

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('talent_ui'):
		visible = !visible

func _on_visibility_changed() -> void:
	if talent_panel:
		if visible:
			get_tree().call_group("talent_group","startAnim")
			await get_tree().create_timer(0.3).timeout
			talent_panel.drawLines()
		else:
			talent_panel.clearLines()

func _on_back_pressed() -> void:
	visible = false
