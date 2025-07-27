extends Control

class_name ItemDetailUI

@onready var texture_rect = %TextureRect
@onready var dialogue_label = $ColorRect/DialogueLabel

var dialogue_line: DialogueLine:
	set(value):
		dialogue_line = value
		update_dialogue()

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.dialogue_ended.connect(_remove_self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_item(texture : Texture2D):
	texture_rect.texture = texture

func remove_ui() :
	queue_free()

func skip_typing() -> void:
	dialogue_label.skip_typing()

func update_dialogue() -> void:
	if dialogue_line.character.is_empty():
		pass
	else:
		pass
	dialogue_label.dialogue_line = dialogue_line
	dialogue_label.type_out()

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
	dialogue_line = next_dialogue_line

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


func _on_gui_input(event):
	handle_click(event)
