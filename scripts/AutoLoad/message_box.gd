extends CanvasLayer

const label_pre = preload("res://scenes/ui/components/message_item.tscn")

@onready var box = $Control/CenterContainer

func alert(text):
	var ins = label_pre.instantiate()
	ins.text = text
	box.add_child(ins)
