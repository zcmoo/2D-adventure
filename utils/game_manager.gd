extends Node
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
var world_states = {}
const SAVE_PATH = "user://data.sav"


func _ready() -> void:
	color_rect.color.a = 0

func change_scene(path: String, params = {}) -> void:
	var tree = get_tree()
	tree.paused = true	
	var players = tree.get_nodes_in_group("player")
	var player = players[0]
	var player_current_health = player.current_health
	var player_current_energy = player.current_energy
	var old_name = tree.current_scene.scene_file_path.get_basename()
	world_states[old_name] = tree.current_scene.to_dict()
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 0.2)
	await tween.finished
	tree.change_scene_to_file(path)
	await tree.tree_changed
	var new_name = tree.current_scene.scene_file_path.get_basename()
	if new_name in world_states:
		tree.current_scene.from_dict(world_states[new_name])
	if "entry_point" in params:
		for node in tree.get_nodes_in_group("entry_points"):
			if node.name == params.entry_point:
				tree.current_scene.update_player(node.global_position, node.direction, player_current_health, player_current_energy)
				break
	if "position" in params and "direction" in params and "current_health" in params and "current_energy" in params:
		tree.current_scene.update_player(params.position, params.direction, int(params.current_health), float(params.current_energy))
	tree.paused = false
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0, 0.2)

func save_game() -> void:
	var scene = get_tree().current_scene
	var scene_name = scene_file_path.get_file().get_basename()
	world_states[scene_name] = scene.to_dict()
	var players = get_tree().get_nodes_in_group("player")
	var player = players[0]
	var player_current_health = player.current_health
	var player_current_energy = player.current_energy
	var player_direction = player.Direction.LEFT if player.sprite_2d.flip_h == true else player.Direction.RIGHT
	var player_position_x = player.global_position.x
	var player_position_y = player.global_position.y
	var data = {
		world_states = world_states,
		scene = scene.scene_file_path,
		player = {
			current_health = player_current_health as int,
			current_energy = player_current_energy as float,
			direction = player_direction,
			position = {
				x = player_position_x,
				y = player_position_y
			}
		}
	}
	var json = JSON.stringify(data)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		return
	file.store_string(json)

func load_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json = file.get_as_text()
	var data = JSON.parse_string(json) as Dictionary
	world_states = data.world_states
	change_scene(data.scene, {
		current_health = data.player.current_health as int,
		current_energy = data.player.current_energy as float,
		direction = data.player.direction,
		position = Vector2(
			data.player.position.x,
			data.player.position.y
		)
	})

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		load_game()
