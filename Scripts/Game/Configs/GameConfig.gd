extends Node

## 被读取类，不参与计算
class_name GameConfigs

# 默认配置
const  config_defaults := {
	"input": {"bindings": {"jump": "ui_accept", "go_left": "A", "go_right": "D", "go_up": "W", "go_down": "S", "boost": "Shift"} },
}

# 交互类型
enum interaction_type {
	npc, #NPC角色
	item, #可交互物体
	mechanism, #可交互机关
	player, #玩家角色
}
