extends Control

class_name DialogueUI

signal finished_typing()
signal spoke(letter: String, letter_index: int, speed: float)

@onready var dialogue_label = $CanvasGroup/PanelContainer/DialogueLabel
@onready var dialogue_responses_menu = $DialogueResponsesMenu
@onready var line_2d = $CanvasGroup/Line2D
@onready var parallax_background = $ParallaxBackground
@onready var big_icon = %BigIcon

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

@export var marker2D : Marker2D = null

var dialogue_line: DialogueLine:
	set(value):
		dialogue_line = value
		update_dialogue()

# 鼠标灵敏度系数
var mouse_sensitivity := Vector2(0.03, 0.03)
# 视差中心偏移量
var parallax_center := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	# 初始化视差中心为当前视口中心
	parallax_center = get_viewport().size / 2
	dialogue_label.finished_typing
	DialogueManager.dialogue_ended.connect(_remove_self)
	

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		# 计算鼠标偏离中心的距离
		var mouse_offset = event.position - parallax_center
		# 应用灵敏度并设置视差偏移
		# parallax_background.scroll_offset = mouse_offset * mouse_sensitivity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if marker2D :
		line_2d.points[1] = marker2D.global_position - line_2d.global_position

func _remove_self(resource: DialogueResource):
	queue_free()

func start(dialogue_resource: DialogueResource, title: String = "start", extra_game_states: Array = []) -> void:
	#if animation_player.is_playing():
		#await animation_player.animation_finished
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	var next_dialogue_line: DialogueLine = await resource.get_next_dialogue_line(title, temporary_game_states)
	dialogue_line = next_dialogue_line

func skip_typing() -> void:
	dialogue_label.skip_typing()

func update_dialogue() -> void:
	if dialogue_line.character.is_empty():
		pass
	else:
		pass
	dialogue_label.dialogue_line = dialogue_line
	dialogue_label.type_out()

func _on_dialogue_label_finished_typing() -> void:
	if is_inside_tree():
		finished_typing.emit()

func _on_dialogue_label_spoke(letter: String, letter_index: int, speed: float):
	if is_inside_tree():
		spoke.emit(letter, letter_index, speed)

func _on_gui_input(event):
	handle_click(event)

func handle_click(event: InputEvent) -> void:
	var is_left_click : bool = event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
	var is_accept_key : bool = event.is_action_pressed("ui_accept")
	if is_left_click or is_accept_key:
		get_viewport().set_input_as_handled()
		if dialogue_label.is_typing :
			skip_typing()
		else:
			next_line(dialogue_line.next_id)

func next_line(next_id: String) -> void:
	var next_dialogue_line : DialogueLine = await resource.get_next_dialogue_line(next_id, [self])
	if not is_instance_valid(next_dialogue_line): return
	if next_dialogue_line.type == DMConstants.TYPE_RESPONSE:
		dialogue_responses_menu.show()
		dialogue_responses_menu.responses = next_dialogue_line.responses
		#dialogue_responses_menu.get_menu_items()[0].grab_focus()
		
	else:
		dialogue_line = next_dialogue_line

func _on_dialogue_responses_menu_response_selected(response):
	next_line(response.next_id)
	dialogue_responses_menu.hide()

func set_icon(texture: Texture2D, marker_2d_pos : Vector2 = Vector2(406, -590)):
	#marker2D.position = marker_2d_pos
	big_icon.texture = texture
	pass
