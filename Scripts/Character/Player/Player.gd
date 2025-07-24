extends CharacterBody3D

class_name Player

const LogManager = CoreSystem.Logger

@onready var head_marker = $head_marker
@onready var movement_component = $MovementComponent

const ConfigManager = CoreSystem.ConfigManager
var config_manager : ConfigManager = CoreSystem.config_manager

var logger : LogManager = CoreSystem.logger
var map_camera : Camera3D = null
var map_phantom : PhantomCamera3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_get_camera()
	_set_map_phantom_binding()
	_apply_demo_defaults()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()

func _get_camera() -> Camera3D:
	#for camera in get_tree().current_scene.get_nodes_in_group("map_camera"):
	if map_camera != null : 
		return map_camera
	else:
		var map_node : Node = get_tree().current_scene
		map_camera = map_node.get_node("map_camera") as Camera3D
		return map_camera
	logger.error("_get_camera can't find a map camera check the map")
	return null
	pass

func _set_map_phantom_binding():
	if map_camera == null : 
		_get_camera()
	var map_node : Node = get_tree().current_scene
	#var phantom : PhantomCamera3D = map_node.get_node("player_follower_phantom") as PhantomCamera3D
	#if phantom != null :
		#map_phantom = phantom
		#map_phantom.follow_target = head_marker
	movement_component.look_at_target = map_phantom

#region 测试代码
## 应用 Demo 特定的默认值
func _apply_demo_defaults():
	for section in GameConfigs.config_defaults:
		for key in GameConfigs.config_defaults[section]:
			# 检查是否需要设置（通常在清空后都需要）
			# if config_manager.get_value(section, key, null) != demo_defaults[section][key]:
			config_manager.set_value(section, key, GameConfigs.config_defaults[section][key])
	logger.info("Demo 默认值已应用。")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		match Input.mouse_mode :
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#region
