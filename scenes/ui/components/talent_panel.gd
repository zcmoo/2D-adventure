extends Panel

var talent_node_dict = {}
var draw_lines = []
var line_color = Color.WHITE

func _ready() -> void:
	for talent_node in get_children():
		talent_node_dict[talent_node.talent.id] = talent_node
		talent_node.talent.position = talent_node.position

func drawLines():
	draw_lines.clear()
	for talent_node in get_children():
		var target_talent = talent_node.talent as Talent
		for talent in target_talent.prerequisites:
			draw_lines.append([target_talent.position,talent_node_dict[talent.id].position])
	queue_redraw()
	
func clearLines():
	draw_lines.clear()
	queue_redraw()

func _draw() -> void:
	for lines in draw_lines:
		var start = lines[0] + Vector2(20,20)
		var end = lines[1] + Vector2(20,20)
		draw_dashed_line(start,end,line_color,1,4,true,false)
