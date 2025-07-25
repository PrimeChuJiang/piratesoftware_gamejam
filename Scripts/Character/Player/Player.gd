extends CharacterBody3D

class_name Player

const LogManager = CoreSystem.Logger

@export var swing_strength: float = 0.2  # 摆动幅度
@export var swing_speed: float = 10.0     # 摆动速度
@export var min_move_speed: float = 0.1  # 触发摆动的最小移动速度

@onready var head_marker = $head_marker
@onready var movement_component = $MovementComponent
@onready var phantom_camera_3d = $PhantomCamera3D

const ConfigManager = CoreSystem.ConfigManager
var config_manager : ConfigManager = CoreSystem.config_manager

var arrow = preload("res://Assets/MouseCursor/arrow.png")

var logger : LogManager = CoreSystem.logger
var map_camera : Camera3D = null

var move_able : bool = true
var base_position: Vector3  # 相机基础位置
var swing_offset: float = 0  # 摆动偏移量
var time: float = 0  # 时间计数器

# Called when the node enters the scene tree for the first time.
func _ready():
	_get_camera()
	_apply_demo_defaults()
	base_position = phantom_camera_3d.position
	Input.set_custom_mouse_cursor(arrow)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float):
	var move_speed : float = Vector2(velocity.x, velocity.z).length()
	if move_speed > min_move_speed:
		time += _delta
		swing_offset = sin(time * swing_speed) * swing_strength * (move_speed / movement_component.max_speed)
	else :
		swing_offset = lerp(swing_offset, 0.0, _delta * 5)
	phantom_camera_3d.position = base_position + Vector3(0, swing_offset, 0)

func _physics_process(delta):
	if move_able:
		move_and_slide()
	else:
		velocity = Vector3.ZERO

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

#region 测试代码
## 应用 Demo 特定的默认值
func _apply_demo_defaults():
	for section in GameConfigs.config_defaults:
		for key in GameConfigs.config_defaults[section]:
			# 检查是否需要设置（通常在清空后都需要）
			# if config_manager.get_value(section, key, null) != demo_defaults[section][key]:
			config_manager.set_value(section, key, GameConfigs.config_defaults[section][key])
	logger.info("Demo 默认值已应用。")

#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#match Input.mouse_mode :
			#Input.MOUSE_MODE_VISIBLE:
				#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#Input.MOUSE_MODE_CAPTURED:
				#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#region
