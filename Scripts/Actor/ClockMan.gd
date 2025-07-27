extends BaseItem2D

@export var look_icon : Texture2D
@export var eye_off : Texture2D
@export var blood : Texture2D
@export var choose : Texture2D


var _dialog_tween : Tween 
var _dictionary : Dictionary[StringName, bool]

func _on_click():
	#phantom_camera_2d.priority = 10
	DialogueManager.dialogue_ended.connect(_dialogue_finish)
	var npc_talk_ui : DialogueUI = npc_talk_ui_pack.instantiate() as DialogueUI
	Hud.add_child(npc_talk_ui)
	npc_talk_ui.start(load("res://Dialogue/5th_room.dialogue"))
	npc_talk_ui.set_icon(look_icon)
func done():
	pass

func _dialogue_finish(resource: DialogueResource):
	#phantom_camera_2d.priority = 1
	#var _camera_2d : Camera2D = get_tree().current_scene.get_node("Camera2D")
	#if _dialog_tween and _dialog_tween.is_running():
		#_dialog_tween.kill()
	#_dialog_tween = create_tween()
	#_dialog_tween.parallel().tween_property(_camera_2d, "position",  Vector2(576, 324), 0.3)
	#_dialog_tween.parallel().tween_property(_camera_2d, "zoom", Vector2(1, 1), 0.3)
	DialogueManager.dialogue_ended.disconnect(_dialogue_finish)

func update_state(dictionary: Dictionary[StringName, bool]) -> void:
	_dictionary = dictionary
