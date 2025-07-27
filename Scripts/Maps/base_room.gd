extends ParallaxBackground

class_name Room

@onready var parallox_layer = $ParalloxLayer

# 鼠标灵敏度系数
var mouse_sensitivity := Vector2(0.03, 0.03)
# 视差中心偏移量
var parallax_center := Vector2.ZERO

func _ready():
	# 初始化视差中心为当前视口中心
	parallax_center = get_viewport().size / 2
	_fresh_scene()
	# 设置鼠标捕获模式以便获取准确位置
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		# 计算鼠标偏离中心的距离
		var mouse_offset = event.position - parallax_center
		# 应用灵敏度并设置视差偏移
		scroll_offset = mouse_offset * mouse_sensitivity

func remove_scene():
	queue_free()

func _fresh_scene():
	pass
	#for _child in parallox_layer.get_children():
		#if _child is BaseItem2D :
			#if _child.type == GameConfigs.interaction_type.item:
				#var _visible = AllParams.room_5_param[_child.item_info.name]
				#if not _visible: 
					#parallox_layer.remove_child(_child)
					#_child.done()
			#elif _child.type == GameConfigs.interaction_type.npc:
				#_child.update_state(AllParams.room_5_param)
