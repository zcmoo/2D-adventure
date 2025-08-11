extends BossState
@onready var pivot: Node2D = %pivot
var can_transition: bool = false


func enter():
	super.enter()
	await play_animation("laser_cast")
	await play_animation("laser")
	can_transition = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func set_target():
	pivot.rotation = (owner.direction_shoot - pivot.position).angle()
	owner.hit_box.rotation = pivot.rotation
	owner.hit_box.monitoring = true

func transition():
	if can_transition:
		can_transition = false
		owner.hit_box.monitoring = false
		get_parent().change_state("Dash")
