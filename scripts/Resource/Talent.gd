extends Resource
class_name Talent

# 天赋的唯一标识符
@export var id: String

# 天赋的名称（显示在界面上）
@export var name: String

@export var useType:Consts.UseType
# 体力消耗
@export var strength: int

# 天赋的描述（显示在界面上，用于解释效果）
@export var description: String

# 天赋类型，例如 "attribute","active"
@export var type: Consts.Type

# 图标文件路径，用于在 UI 上展示
@export var icon: Texture

# 天赋的最大等级
@export var max_level: int

@export var effects: Array[Effects] # 天赋的效果

@export var prerequisites: Array[Talent] # 前置条件，数组形式，存储解锁此天赋需要的其他天赋 ID

# 天赋在天赋树界面中的位置（二维坐标）
@export var position: Vector2

@export var branches: Array # 后续分支天赋，数组形式，存储其他天赋 ID

@export var bindKye:String # 绑定物理按键映射

# 当前等级
var current_level: int

func get_dynamic_description() -> String:
	var desc = description

	# 遍历所有效果，动态计算总值
	for effect in effects:
		if effect.get("attribute") and effect.get("value"):
			var attribute = effect["attribute"]  # 效果影响的属性，例如 "strength"
			var value = effect["value"]         # 单级效果值
			
			var total_value = value * (current_level if current_level != 0 else 1) # 根据等级计算总值
			desc = desc.replace("(%s)" %attribute, str(total_value))
	return desc
