extends CharacterBody2D
class_name Enemy

@onready var state_machine = $EnemyStateMachine
@onready var anim_player = $Body/AnimatedSprite2D
@onready var body = $Body
@onready var atk_area = $Body/AtkArea

var is_invincible_frame = false # 是否是无敌帧
var is_atking = false # 是否处于攻击模式
var is_knocked_back = false  # 是否处于击退状态
@export var friction = 100  # 击退摩擦力

const GRAVITY = 600  # 重力
# 当前朝向，1 表示向右，-1 表示向左
var facing_direction = 0

var speed = 120.0  # 移动速度

func _ready() -> void:
	state_machine.change_state("Idle")

func _physics_process(delta):
	if is_knocked_back:
		# 添加摩擦力逐渐减速
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		state_machine.update(delta)
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	move_and_slide()

func take_damage(damage):
	EffectUtils.show_floating_text('-%s' %damage,global_position)
	if is_invincible_frame == false:
		state_machine.change_state("Hit")

# 处理击退
func apply_knockback(knockback_force: Vector2, duration: float):
	if is_invincible_frame && knockback_force.x < 100:
		return
	is_knocked_back = true
	velocity += knockback_force  # 添加击退速度
	# 设置击退结束计时器
	await get_tree().create_timer(duration).timeout
	is_knocked_back = false  # 结束击退状态
	velocity = Vector2.ZERO  # 停止击退速度

# 修改动画
func changeAnim(_name,callable = null):
	anim_player.play(_name)
	if anim_player.sprite_frames.get_animation_loop(_name) == false && callable:
		await anim_player.animation_finished
		callable.call()

#转向
func flip_h(flip:bool):
	var x_axis = body.global_transform.x
	body.global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)
	#body.global_transform.x.x = flip * abs(x_axis.x)

#检测攻击目标
func checkAtk() -> Player:
	for body in atk_area.get_overlapping_bodies():
		if body is Player:
			return body
	return null

# 获取角色面向的方向（-1 或 1）
func get_facing_direction():
	return Vector2(sign(body.global_transform.x.x), 0)  # 根据角色缩放方向判断
