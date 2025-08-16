extends BossState
@export var bullet_node: PackedScene
var can_transition: bool = false


func enter():
	super.enter()
	animation_player.play("range_attack")
	await animation_player.animation_finished
	shoot()
	can_transition = true

func shoot():
	var bullet = bullet_node.instantiate()
	SoundManager.play_sfx("Bullet")
	bullet.position = owner.position
	bullet.player = owner.player
	bullet.boss = owner
	get_tree().current_scene.add_child(bullet)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
