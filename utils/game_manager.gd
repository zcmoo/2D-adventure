extends Node


func change_scene(path: String, entry_point: String) -> void:
	var tree = get_tree()
	var players = get_tree().get_nodes_in_group("player")
	var player = players[0]
	var player_current_health = player.current_health
	tree.change_scene_to_file(path)
	await tree.tree_changed
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position, node.direction, player_current_health)
			break
