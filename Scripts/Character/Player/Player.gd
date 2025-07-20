extends CharacterBody3D

class_name Player

const LogManager = CoreSystem.Logger

@onready var head_marker = $head_marker
@onready var movement_component = $MovementComponent

var logger : LogManager = CoreSystem.logger
var map_camera : Camera3D = null
var map_phantom : PhantomCamera3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_get_camera()
	_set_map_phantom_binding()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()

# TODO: 需要一个方法能够快速拿到地图内的摄像机
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
	var phantom : PhantomCamera3D = map_node.get_node("player_follower_phantom") as PhantomCamera3D
	if phantom != null :
		map_phantom = phantom
		map_phantom.follow_target = head_marker
		movement_component.look_at_target = map_phantom
