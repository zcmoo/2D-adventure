extends CharacterBody2D
class_name Player

# 状态机
@onready var state_machine: StateMachine = $StateMachine
@onready var anim_player :AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body = $Body
@onready var atk_checks = $Body/AtkChecks
@onready var audios = $Audios

var is_knocked_back = false # 是否处于击退状态
@export var friction = 100  # 击退摩擦力
const GRAVITY = 600  # 重力
# 当前朝向，1 表示向右，-1 表示向左
var facing_direction = 0

var speed = 200.0  # 移动速度

signal on_player_move(_velocity)

func _ready() -> void:
	Game.player = self
	state_machine.change_state("Idle")
	PlayerData.useHp(100)

func _physics_process(delta):
	if is_knocked_back:
		# 添加摩擦力逐渐减速
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		on_player_move.emit(velocity)
	#else:
		#state_machine.update(delta)
		#on_player_move.emit(velocity)
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	move_and_slide()

func _process(delta: float) -> void:
	if !is_knocked_back:
		state_machine.update(delta)

# 处理击退
func apply_knockback(knockback_force: Vector2, duration: float):
	if state_machine.current_state.name == 'Dash':
		return
	is_knocked_back = true
	velocity += knockback_force  # 添加击退速度

	# 设置击退结束计时器
	await get_tree().create_timer(duration).timeout
	is_knocked_back = false  # 结束击退状态
	velocity = Vector2.ZERO  # 停止击退速度

func take_damage(damage,enemy:Enemy):
	if state_machine.current_state.name == 'Parry':
		Game.time_scale_frame(0.5,0.05)
		state_machine.change_state("ParryAtk")
		enemy.take_damage(10)
		Game.knockback(self,enemy,120,-25)
		return
	if state_machine.current_state.name == 'Dash':
		Game.time_scale_frame(0.2,0.3)
		return
	if state_machine.current_state.name == 'Block':
		state_machine.current_state.doBlock(enemy)
	else:
		state_machine.change_state("Hit")
		var last_damage = roundi(damage * (1 - PlayerData.player_def / 100.0))
		PlayerData.useHp(-last_damage)
		MessageBox.alert("受到伤害-%s" %last_damage)

# 修改动画
func changeAnim(_name,callable = null):
	anim_player.play(_name)
	if anim_player.sprite_frames.get_animation_loop(_name) == false && callable:
		await anim_player.animation_finished
		callable.call()

#转向
func flip_h(flip:int):
	if facing_direction != flip:
		facing_direction = flip
		var x_axis = body.global_transform.x
		#body.global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)
		body.global_transform.x.x = flip * abs(x_axis.x)

# 设置偏移
func setAnimOffset(offset):
	anim_player.offset = offset

# 获取攻击范围
func getAtkChecksArea(_name:String):
	return atk_checks.get_node(_name)

# 获取攻击范围
func playAudios(_name:String):
	var audio = audios.get_node(_name)
	if audio:
		audio.play() 

# 获取角色面向的方向（-1 或 1）
func get_facing_direction():
	return Vector2(sign(body.global_transform.x.x), 0)  # 根据角色缩放方向判断

# 检测当前范围目标
func checkHit(_name) -> Array:
	var enemies = []
	#var damage = combo_count * 10  # 假设每段伤害递增
	var attack_range = getAtkChecksArea(_name)
	if attack_range:
		for body in attack_range.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				enemies.append(body)
	return enemies
