extends Node

enum UpgradeStatus {
	SUCCESS, # 成功
	NO_PRE, # 缺少前置
	MAX_LEVEL # 等级已满
}

var player_talents = {} # 玩家持有天赋

signal on_talent_click(talent:Talent)
signal on_talent_upgrade(talent:Talent) # 天赋升级

# 获取天赋
func getTalent(id) -> Talent:
	if player_talents.has(id):
		return player_talents.get(id)
	return null

# 升级天赋
func upgradeTalent(_talent:Talent) -> UpgradeStatus:
	if _talent.prerequisites.size() > 0:
		for pre in _talent.prerequisites:
			if not player_talents.has(pre.id):
				MessageBox.alert("缺少前置天赋："+pre.name)
				return UpgradeStatus.NO_PRE
	
	var talent :Talent = player_talents.get(_talent.id)
	if talent:
		if talent.current_level < talent.max_level:
			talent.current_level += 1
			on_talent_upgrade.emit(talent)
			MessageBox.alert("天赋[%s]提升至Lv%s" %[talent.name,talent.current_level])
			return UpgradeStatus.SUCCESS
		else:
			MessageBox.alert("天赋已达到最大等级："+talent.name)
			return UpgradeStatus.MAX_LEVEL
	else:
		player_talents[_talent.id] = _talent
		player_talents[_talent.id].current_level += 1
		on_talent_upgrade.emit(player_talents[_talent.id])
		MessageBox.alert("已学习天赋："+player_talents[_talent.id].name)
		return UpgradeStatus.SUCCESS
