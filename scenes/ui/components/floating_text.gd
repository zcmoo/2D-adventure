extends Node2D

@export var float_distance: float = 50  # 飘字移动的距离
@export var duration: float = 1.0  # 飘字持续时间
@export var start_color: Color = Color(1, 1, 1, 1)  # 初始颜色
@export var end_color: Color = Color(1, 1, 1, 0)  # 最终颜色

func _ready():
	modulate = start_color
	play_animation()

func play_animation():
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self,"scale",Vector2(1.5,1.5),0.2).from(Vector2(0.5,0.5))
	tween.tween_property(self,"scale",Vector2(1,1),0.1).from(Vector2(1.5,1.5))
	
	tween.tween_property(self,"position:y",self.position.y - 20,0.3).set_delay(0.3)
	tween.parallel().tween_property(self,"modulate:a",0.0,0.3).set_delay(0.3)
	
	tween.tween_callback(self.queue_free)
