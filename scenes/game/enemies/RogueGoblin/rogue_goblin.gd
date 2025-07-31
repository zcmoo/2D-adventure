extends Enemy

var ranged_atk_count = 10

func _on_atk_area_body_entered(body: Node2D) -> void:
	if body is Player:
		state_machine.change_state("Atk")


func _on_timer_timeout() -> void:
	ranged_atk_count += 1
	var dis = global_position.distance_to(Game.player.global_position)
	if dis > 100 && ranged_atk_count >= 10:
		ranged_atk_count = 0
	
	var hit_body = checkAtk()
	if hit_body:
		state_machine.change_state("Atk")
		return
	
	if is_atking == false:
		state_machine.change_state("Pathfinding")
