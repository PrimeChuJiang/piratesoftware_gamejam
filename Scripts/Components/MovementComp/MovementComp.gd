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
@export_group("FirstPersonPhantom")
@export var first_person_phantom : PhantomCamera3D

const LogManager = CoreSystem.Logger
const ConfigManager = CoreSystem.ConfigManager
const InputManager = CoreSystem.InputManager
const MOVEMENT_AXIS = "ground_move"

var logger : LogManager = CoreSystem.logger
var config_manager : ConfigManager = CoreSystem.config_manager
var input_manager : InputManager = CoreSystem.input_manager

var INPUT_ACTIONS : Variant = config_manager.get_value("input", "bindings", GameConfigs.config_defaults.input.bindings)




var state_machine_manager : CoreSystem.StateMachineManager = CoreSystem.state_machine_manager
var look_at_target : Node3D = null

var speed_up_acc : float
var speed_down_acc : float
var jump_up_acc : float
var jump_down_acc : float
var jump_speed : float
# Stores the direction the player is trying to look this frame.
var _look := Vector2.ZERO
var can_jump : bool = true

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
	#var movement_state_machine : MovementStateMachine = MovementStateMachine.new()
	#movement_state_machine.MovementComp = self
	#state_machine_manager.register_state_machine(&"player_movement", movement_state_machine, self, &"ground")
	#
	input_manager.virtual_axis.register_axis(
		MOVEMENT_AXIS,
		INPUT_ACTIONS.go_right,
		INPUT_ACTIONS.go_left,
		INPUT_ACTIONS.go_down,
		INPUT_ACTIONS.go_up
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	count_movement_property()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_look = -event.relative * mouse_sensitivity
	#if event.is_action_pressed(INPUT_ACTIONS.jump) and can_jump:
		#character.velocity.y = jump_speed

func _physics_process(_delta: float) -> void:
	frame_camera_rotation()
	var input_dir : Vector2 = input_manager.virtual_axis.get_axis_value(MOVEMENT_AXIS)
	_character_movement(input_dir, _delta)

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

func frame_camera_rotation() -> void:
	character.rotate_y(_look.x)
	first_person_phantom.rotate_x(_look.y)
	first_person_phantom.rotation.x = clamp(first_person_phantom.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	_look = Vector2.ZERO

## 玩家移动函数
func _character_movement(input_dir : Vector2, _delta : float):
	#can_jump = character.is_on_floor()
	# 将2D输入转换为3D空间方向
	var world_dir : Vector3 = (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed : Vector3 = character.velocity
	var target_velocity = world_dir * max_speed
	#if world_dir.x != 0 :
		#if _character_velocity_dir.x * world_dir.x >= 0:
			#current_speed.x = move_toward(current_speed.x, max_speed * world_dir.x, speed_up_acc * _delta)
			##current_speed.x = lerp(current_speed.x, _character_velocity_dir.x*max_speed, current_speed.length()/speed_up_acc)
		#else :
			#current_speed.x = move_toward(current_speed.x, 0, speed_down_acc * _delta)
	#elif can_jump:
		#current_speed.x = move_toward(current_speed.x, 0, speed_down_acc * _delta)
		#
	#if world_dir.z != 0 :
		#if _character_velocity_dir.z * world_dir.z >= 0:
			#current_speed.z = move_toward(current_speed.z, max_speed * world_dir.z, speed_up_acc * _delta)
			##current_speed.z = lerp(current_speed.z, _character_velocity_dir.z*max_speed, current_speed.length()/speed_up_acc)
		#else :
			#current_speed.z = move_toward(current_speed.z, 0, speed_down_acc * _delta)
	#elif can_jump:
		#current_speed.z = move_toward(current_speed.z, 0, speed_down_acc * _delta)
	#
	
	if input_dir != Vector2.ZERO:
		current_speed.z = move_toward(current_speed.z, target_velocity.z, speed_up_acc* _delta)
		current_speed.x = move_toward(current_speed.x, target_velocity.x, speed_up_acc* _delta)

		print(current_speed)
	else:
		var speed = current_speed.length()
		if speed > 0 :
			var new_speed = move_toward(speed, 0, speed_down_acc* _delta)
			current_speed = current_speed.normalized() * new_speed
		else:
			current_speed = Vector3(0, current_speed.y, 0)
	## y轴方向变化
	#if not can_jump:
		#if(current_speed.y > 0):
			#current_speed.y = move_toward(current_speed.y, 0, jump_up_acc * _delta)
		#else:
			#if current_speed.y > -jump_speed :
				#current_speed.y = move_toward(current_speed.y, -jump_speed - 0.1, jump_down_acc * _delta)
			#else :
				#current_speed.y -= jump_down_acc*_delta
	#else:
		#current_speed.y = 0
	current_speed.y = 0
	character.velocity = current_speed

func _on_action_triggered(action_name:String, event:InputEvent):
	match action_name:
		INPUT_ACTIONS.jump:
			character.velocity.y = jump_speed
