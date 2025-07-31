extends Label

func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self,"scale",Vector2(1,1),0.3).from(Vector2(1.3,1.3))
	tween.parallel().tween_property(self,"modulate:a",1.0,0.3).from(0.0)

	tween.tween_callback(self.finish)

func finish():
	await get_tree().create_timer(1).timeout
	var tween = create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self,"position:y",position.y - 10,0.3)
	tween.parallel().tween_property(self,"modulate:a",0.0,0.3).from(1.0)
	tween.tween_callback(self.queue_free)
