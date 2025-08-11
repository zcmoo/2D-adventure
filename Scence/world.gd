extends Node2D
@onready var tile_map_layer: TileMapLayer = $TileMap/ground
@onready var camera_2d: Camera2D = $player/Camera2D
@onready var player: Player = $player


func _ready() -> void:
	var used = tile_map_layer.get_used_rect().grow(-1)
	var tile_size = tile_map_layer.tile_set.tile_size
	camera_2d.limit_top = used.position.y * tile_size.y
	camera_2d.limit_right = used.end.x * tile_size.x
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()

func update_player(pos: Vector2, direction: Player.Direction, player_current_health: int, player_current_energy: int) -> void:
	player.current_health = player_current_health
	DamageManager.health_change.emit(player, player.current_health, player.health, true)
	player.current_energy = player_current_energy
	EnergyManager.energy_change.emit(player.current_energy, player.energy)
	player.global_position = pos
	player.set_entry_heading(direction)
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()

func to_dict() -> Dictionary:
	var enemies_alive = []
	var player_current_health: int
	var tree = get_tree()
	for node in tree.get_nodes_in_group("enemies"):
		var path = get_path_to(node) as String
		enemies_alive.append(path)
	var players = tree.get_nodes_in_group("player")
	var player = players[0]
	player_current_health = player.current_health
	return {
		enemies_alive = enemies_alive,
		player_current_health = player_current_health
	}

func from_dict(dict: Dictionary) -> void:
	var tree = get_tree()
	for node in tree.get_nodes_in_group("enemies"):
		var path = get_path_to(node) as String
		if path not in dict.enemies_alive:
			node.queue_free()
	var players = tree.get_nodes_in_group("player")
	var player = players[0]
	player.current_health = dict.player_current_health
	DamageManager.health_change.emit(player, player.current_health, player.health, true)
		

	

	
