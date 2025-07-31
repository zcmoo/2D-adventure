extends Sprite2D

# 残影存在时间
var fade_time = 0.2
var timer = 0

func _ready():
	timer = fade_time

func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()  # 时间到后销毁
		set_process(false)
	else:
		# 逐渐减少透明度
		modulate.a = min(0.4,timer / fade_time)
