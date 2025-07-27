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

var current_hovering_node : Base3DSprite

var items : Array[ResourceItem]

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

func _input(event):
	if event.is_action_pressed("Q"):
		pass

func _get_camera() -> Camera3D:
	#for camera in get_tree().current_scene.get_nodes_in_group("map_camera"):
	if map_camera != null : 
		return map_camera
	else:
		var map_node : Node = get_tree().get_nodes_in_group("subviewport")[0].get_child(0)
		map_camera = map_node.get_node("map_camera") as Camera3D
		return map_camera
	logger.error("_get_camera can't find a map camera check the map")
	return null
	pass

func add_item(item : ResourceItem):
	items.append(item)
	Hud.get_node("ItemListUI").add_item(item)

func remove_item(item : ResourceItem):
	items.remove_at(items.find(item))
	Hud.get_node("ItemListUI").remove_item(item)

func up_gun():
	pass

func down_gun():
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

func spawn_ray_cast():
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	# 创建射线
	var ray_start = map_camera.project_ray_origin(mouse_pos)
	var ray_end = ray_start + map_camera.project_ray_normal(mouse_pos) * 10000
	# 射线检测
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_query_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query_param.collision_mask = 2
	ray_query_param.from = ray_start
	ray_query_param.to = ray_end
	var result : Dictionary = space_state.intersect_ray(ray_query_param)
	
	if result:
		print(result["collider"])
	
	if result and result["collider"] == InteractionComp :
		var _collider : InteractionComp = result["collider"]
		var _collider_owner : Base3DSprite = _collider.parent_actor as Base3DSprite
		if _collider_owner == null : return
		if current_hovering_node != _collider_owner :
			current_hovering_node.hovering = false
			_collider_owner.hovering = true

#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#match Input.mouse_mode :
			#Input.MOUSE_MODE_VISIBLE:
				#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#Input.MOUSE_MODE_CAPTURED:
				#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#region
