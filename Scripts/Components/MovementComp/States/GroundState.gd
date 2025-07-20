extends BaseState
class_name GroundState

const ConfigManager = CoreSystem.ConfigManager
const LogManager = CoreSystem.Logger
const InputManager = CoreSystem.InputManager
var config_manager : ConfigManager = CoreSystem.config_manager
var logger : LogManager = CoreSystem.logger
var input_manager : InputManager = CoreSystem.input_manager

var can_jump : bool 
var boost_muti : float = 1.0

const MOVEMENT_AXIS = "ground_move"
var INPUT_ACTIONS : Variant = config_manager.get_value("input", "bindings", GameConfigs.config_defaults.input.bindings)

## 准备
func _ready() -> void:
	_apply_demo_defaults()
	
	# 设置默认参数
	# input_manager.virtual_axis.set_sensitivity(config_manager.get_value("input", "sensitivity", GameConfigs.config_defaults.input.sensitivity))
	# input_manager.virtual_axis.set_deadzone(config_manager.get_value("input", "deadzone", GameConfigs.config_defaults.input.deadzone))

## 清理
func _dispose() -> void:
	pass

## 进入状态
func _enter(_msg: Dictionary = {}) -> void:
	input_manager.virtual_axis.register_axis(
		MOVEMENT_AXIS,
		INPUT_ACTIONS.go_right,
		INPUT_ACTIONS.go_left,
		INPUT_ACTIONS.go_down,
		INPUT_ACTIONS.go_up
	)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

## 退出状态
func _exit() -> void:
	input_manager.virtual_axis.unregister_axis(MOVEMENT_AXIS)

## 更新
func _update(_delta: float) -> void:
	#if input_manager.input_state.is_pressed(INPUT_ACTIONS.jump):
		#state_machine.MovementComp.character.velocity.y = state_machine.MovementComp.jump_speed
	pass

## 物理更新
func _physics_update(_delta: float) -> void:
	# 获取输入方向
	var input_dir : Vector2 = input_manager.virtual_axis.get_axis_value(MOVEMENT_AXIS)
	# 旋转角色
	#state_machine.MovementComp.turn_character(input_dir)
	# 移动角色
	_character_movement(input_dir, _delta)

## 处理输入
func _handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed(INPUT_ACTIONS.jump) and can_jump:
		state_machine.MovementComp.character.velocity.y = state_machine.MovementComp.jump_speed
	if _event.is_action_pressed(INPUT_ACTIONS.boost):
		boost_muti = state_machine.MovementComp.run_boost_time
	if _event.is_action_released(INPUT_ACTIONS.boost):
		boost_muti = 1.0
	if _event is InputEventMouseMotion :
		state_machine.MovementComp.rotate_head(_event)

## 处理未被处理的输入
func _unhandled_input(_event: InputEvent) -> void:
	_debug(_event.as_text())
	

## 玩家移动函数
func _character_movement(input_dir : Vector2, _delta : float):
	can_jump = state_machine.MovementComp.character.is_on_floor()
	state_machine = state_machine as MovementStateMachine
	# 当前角色速度方向(单位向量)
	var _character_velocity_dir : Vector3 = (state_machine.MovementComp.character.velocity).normalized()
	# 将2D输入转换为3D空间方向
	var world_dir : Vector3 = (state_machine.MovementComp.look_at_target.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if world_dir.x != 0 :
		if _character_velocity_dir.x * world_dir.x >= 0:
			state_machine.MovementComp.character.velocity.x = move_toward(state_machine.MovementComp.character.velocity.x, state_machine.MovementComp.max_speed * world_dir.x * boost_muti, state_machine.MovementComp.speed_up_acc * _delta)
		else :
			state_machine.MovementComp.character.velocity.x = move_toward(state_machine.MovementComp.character.velocity.x, 0, state_machine.MovementComp.speed_down_acc * _delta)
	elif can_jump:
		state_machine.MovementComp.character.velocity.x = move_toward(state_machine.MovementComp.character.velocity.x, 0, state_machine.MovementComp.speed_down_acc * _delta)
		
	if world_dir.z != 0 :
		if _character_velocity_dir.z * world_dir.z >= 0:
			state_machine.MovementComp.character.velocity.z = move_toward(state_machine.MovementComp.character.velocity.z, state_machine.MovementComp.max_speed * world_dir.z * boost_muti, state_machine.MovementComp.speed_up_acc * _delta)
		else :
			state_machine.MovementComp.character.velocity.z = move_toward(state_machine.MovementComp.character.velocity.z, 0, state_machine.MovementComp.speed_down_acc * _delta)
	elif can_jump:
		state_machine.MovementComp.character.velocity.z = move_toward(state_machine.MovementComp.character.velocity.z, 0, state_machine.MovementComp.speed_down_acc * _delta)
	
	
	# y轴方向变化
	if not can_jump:
		if(_character_velocity_dir.y > 0):
			state_machine.MovementComp.character.velocity.y = move_toward(state_machine.MovementComp.character.velocity.y, 0, state_machine.MovementComp.jump_up_acc * _delta)
		else:
			if state_machine.MovementComp.character.velocity.y > -state_machine.MovementComp.jump_speed :
				state_machine.MovementComp.character.velocity.y = move_toward(state_machine.MovementComp.character.velocity.y, -state_machine.MovementComp.jump_speed - 0.1, state_machine.MovementComp.jump_down_acc * _delta)
			else :
				state_machine.MovementComp.character.velocity.y -= state_machine.MovementComp.jump_down_acc*_delta


func _on_action_triggered(action_name:String, event:InputEvent):
	match action_name:
		INPUT_ACTIONS.jump:
			state_machine.MovementComp.character.velocity.y = state_machine.MovementComp.jump_speed

#region 测试代码
## 应用 Demo 特定的默认值
func _apply_demo_defaults():
	for section in GameConfigs.config_defaults:
		for key in GameConfigs.config_defaults[section]:
			# 检查是否需要设置（通常在清空后都需要）
			# if config_manager.get_value(section, key, null) != demo_defaults[section][key]:
			config_manager.set_value(section, key, GameConfigs.config_defaults[section][key])
	logger.info("Demo 默认值已应用。")
#region
