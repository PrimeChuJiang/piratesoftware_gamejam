extends Resource

## 物品的资源类
class_name ResourceItem

@export var id : int # 物品唯一id
@export var name : StringName # 物品名称
@export var description : DialogueResource # 物品描述
@export var small_icon : Texture2D # 物品图表(小)
@export var item_3d : PackedScene # 物品详情展示对象
@export var big_icon : Texture2D # 物品图标(大)
