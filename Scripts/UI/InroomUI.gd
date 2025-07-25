extends Control

class_name InroomUI

@export var _owner : Door
@export var _player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent):
	if event.is_action_pressed("Q"):
		_owner._quit_door(_player)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		queue_free()
