extends Node
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
var world_states = {}
const SAVE_PATH = "user://data.sav"
signal camera_should_shake(amount: float)
var player_current_health: int
var player_current_energy: float


func _ready() -> void:
	color_rect.color.a = 0

func new_game() -> void:
	change_scene("res://Scence/worlds/forest.tscn", {}, true, 1.0)

func back_to_title() -> void:
	world_states = {}
	change_scene("res://UI/title_screen.tscn", {}, false, 1.0)

func change_scene(path: String, params = {}, should_init = false, duration = 0.5) -> void:
	var tree = get_tree()
	tree.paused = true	
	var players = tree.get_nodes_in_group("player")
	var old_name = tree.current_scene.scene_file_path.get_basename()
	if tree.current_scene is World:
		var player = players[0]
		player_current_health = player.current_health
		player_current_energy = player.current_energy
		world_states[old_name] = tree.current_scene.to_dict()
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, duration)
	await tween.finished
	tree.change_scene_to_file(path)
	await tree.tree_changed
	if tree.current_scene is World:
		var new_name = tree.current_scene.scene_file_path.get_basename()
		if new_name in world_states and not should_init:
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
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, duration)

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
	}, false, 1.0)

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)
