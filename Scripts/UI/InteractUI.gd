extends Control

class_name InteractionUI

@onready var color_rect : ColorRect = $ColorRect
@onready var in_room_ui_packedscene : PackedScene = preload("res://Scene/UI/InRoomUI.tscn")

@export var marker : Marker3D = null
@export var _camera : Camera3D = null
@export var _owner : Door = null
@export var _player : Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_scene : Node = get_tree().current_scene
	_camera = current_scene.get_node("map_camera")
	_player = current_scene.get_node("Player")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if marker == null:
		push_error("marker is null !!!!!!!")
	if _camera == null:
		push_error("camera is null !!!!!!!")
	
	if _camera.is_position_in_frustum(marker.global_position):
		color_rect.visible = true
		var screen_pos = _camera.unproject_position(marker.global_position)
		color_rect.set_position(screen_pos-color_rect.size/2)
	else :
		color_rect.visible = false

func _input(event:InputEvent):
	if event.is_action_pressed("Space"):
		_player.move_able = false
		_owner.start_interact()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var in_room_ui : InroomUI = in_room_ui_packedscene.instantiate() as InroomUI
		in_room_ui._owner = _owner
		in_room_ui._player = _player
		Hud.add_child(in_room_ui)
