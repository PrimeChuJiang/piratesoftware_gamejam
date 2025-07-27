extends Node2D

class_name BaseItem2D

@export var type : GameConfigs.interaction_type
@export var item_info : ResourceItem

@onready var sprite_2d = $Sprite2D
@onready var marker_2d = $Marker2D

const item_detail_ui_pack : PackedScene = preload("res://Scene/UI/item_detail_ui.tscn")
const npc_talk_ui_pack : PackedScene = preload("res://Scene/UI/DialogueUI.tscn")

var sprite_2d_shader : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	var shader : ShaderMaterial = ShaderMaterial.new()
	shader.shader = load("res://Shaders/outline_shader.gdshader") 
	shader.set_shader_parameter("outline_color", Color.WHITE)
	sprite_2d.material =  shader.duplicate()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

var out_line_tween : Tween
func _on_rigid_body_2d_mouse_entered():
	print("mouse_entered")
	if out_line_tween and out_line_tween.is_running():
		out_line_tween.kill()
	out_line_tween = create_tween()
	out_line_tween.tween_method(_set_out_line_width, _get_out_line_width(), 5.0, 0.5)

func _on_rigid_body_2d_mouse_exited():
	if out_line_tween and out_line_tween.is_running():
		out_line_tween.kill()
	out_line_tween = create_tween()
	out_line_tween.tween_method(_set_out_line_width, _get_out_line_width(), 0.0, 0.5)

func _on_rigid_body_2d_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_on_click()

func _set_out_line_width(thickness: float) -> void:
	sprite_2d_shader = sprite_2d.material as ShaderMaterial
	sprite_2d_shader.set_shader_parameter("thickness", thickness)

func _get_out_line_width() -> float:
	sprite_2d_shader = sprite_2d.material as ShaderMaterial
	return sprite_2d_shader.get_shader_parameter("thickness") as float

func _on_click()->void:
	print("on click")

func done() ->void:
	print("done")

func update_state(dictionary : Dictionary[StringName, bool]) -> void:
	print(update_state)
