extends Node3D
class_name MovementComp
@export_group("角色","")
@export var character : Player 
@export_group("Ground", "")
@export var max_speed : float
@export var speed_up_time : float
@export var speed_down_time : float
@export var jump_up_time : float
@export var jump_down_time : float
@export var jump_height : float
@export var run_boost_time : float
@export_group("LookAt")
@export var mouse_sensitivity : float

const LogManager = CoreSystem.Logger

@onready var logger : LogManager = CoreSystem.logger

var state_machine_manager : CoreSystem.StateMachineManager = CoreSystem.state_machine_manager
var look_at_target : Node3D = null

var speed_up_acc : float
var speed_down_acc : float
var jump_up_acc : float
var jump_down_acc : float
var jump_speed : float

func count_movement_property() -> void :
	speed_up_acc = max_speed / speed_up_time
	speed_down_acc = max_speed / speed_down_time
	jump_up_acc = (2*jump_height)/pow(jump_up_time, 2)
	jump_down_acc = (2*jump_height)/pow(jump_down_time, 2)
	jump_speed = jump_up_acc * jump_up_time
	logger.info("角色运动数据计算完成", {"speed_up_acc": speed_up_acc, "speed_down_acc": speed_down_acc, "jump_up_acc": jump_up_acc, "jump_down_acc": jump_down_acc, "jump_speed": jump_speed})
	

func get_movement_statemachine() -> MovementStateMachine :
	return state_machine_manager.get_state_machine(&"player_movement") as MovementStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	# 注册状态机
	var movement_state_machine : MovementStateMachine = MovementStateMachine.new()
	movement_state_machine.MovementComp = self
	state_machine_manager.register_state_machine(&"player_movement", movement_state_machine, self, &"ground")
	
	count_movement_property()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var character_rotation_tween : Tween
## 角色转向
func turn_character(input_direction : Vector2):
	if input_direction == Vector2.ZERO : return 
	
	# 将输入方向从局部空间转换为世界空间，忽略Y轴
	var _dir : Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var _move_dir : Vector3 = Vector3.ZERO
	_move_dir.x = _dir.x
	_move_dir.z = _dir.z
	
	var _camera : Camera3D = character.map_camera
	
	_move_dir = _move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
	
	# 计算目标四元数表示的旋转，避免欧拉角问题
	var target_quaterion : Quaternion = Quaternion(Vector3.UP, atan2(_move_dir.x, _move_dir.z))
	
	# 创建补间动画，将角色转向目标方向
	if character_rotation_tween and character_rotation_tween.is_running() :
		character_rotation_tween.kill()
	character_rotation_tween = create_tween()
	character_rotation_tween.tween_property(character.mesh_instance_3d, "quaternion", target_quaterion, 0.1)

var yaw = 0.0
var pitch = 0.0

func rotate_head(_event: InputEvent):
	if look_at_target == null : return
	if _event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= _event.relative.x * mouse_sensitivity
		pitch -= _event.relative.y * mouse_sensitivity
		
		pitch = clampf(pitch, deg_to_rad(-89.9), deg_to_rad(89.9))
		
		look_at_target.rotation = Vector3(pitch, yaw, 0)
		#look_at_target.rotate_y(-_event.relative.x * mouse_sensitivity)
		#look_at_target.rotate_x(-_event.relative.y * mouse_sensitivity)
		#look_at_target.rotation.x = clampf(look_at_target.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))
