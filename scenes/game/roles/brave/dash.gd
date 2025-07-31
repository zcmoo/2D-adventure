extends State

@export var trail_interval = 0.05  # 每隔多少秒生成一个残影
@export var dash_duration = 0.2  # Dash 持续时间

var trail_timer = 0

var dash_cooldown = 1.0       # 冲刺冷却时间（秒）

# 内部变量
var cooldown_timer = 0.0      # 冷却计时器
var dash_direction = Vector2.ZERO  # 冲刺方向

func preMethod():
	var talent = TalentUtils.getTalent('storm_03')
	if talent && PlayerData.useMp(talent):
		return true
	return false

func enter(params = {}):
	# 初始化冲刺状态
	if params.has("direction"):  # 支持传入方向参数
		dash_direction = params["direction"]
	if dash_direction.x == 0:
		dash_direction = player.get_facing_direction()  # 获取角色当前面向方向
	player.velocity.x = lerp(player.velocity.x, dash_direction.x * player.speed * 4, 0.5)
	# 设置冲刺动画
	player.changeAnim("dash",func finish():
		state_machine.change_state("Idle"))

	# 禁用冷却
	cooldown_timer = dash_cooldown

func update(delta):
	player.velocity.x = lerp(player.velocity.x, dash_direction.x * player.speed * 2, 0.5)
	# 冷却计时更新
	cooldown_timer = max(0.0, cooldown_timer - delta)
	
	trail_timer -= delta

	# 在 Dash 过程中定时生成残影
	if trail_timer <= 0:
		
		EffectUtils.create_trail({
			"texture":player.anim_player.sprite_frames.get_frame_texture(player.anim_player.animation,player.anim_player.frame),
			"global_position":player.global_position,
			"offset":player.anim_player.position,
			"transform":player.body.global_transform.x.x
		})
		trail_timer = trail_interval
