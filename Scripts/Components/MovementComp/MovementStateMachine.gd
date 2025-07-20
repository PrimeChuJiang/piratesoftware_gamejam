extends BaseStateMachine
class_name MovementStateMachine

# TODO: 运动状态机第一层目前需要增加三种状态：1.平地状态(普通状态) 2.推拉箱子状态 
#		3.禁止移动状态(此时可能正在别的页面内或是各种各样的交互中)

var MovementComp : MovementComp = null

func _ready() -> void:
	add_state(&"ground", GroundState.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
