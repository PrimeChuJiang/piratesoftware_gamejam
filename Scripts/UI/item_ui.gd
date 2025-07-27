extends Control

class_name ItemUI

@onready var texture_rect = $TextureRect

var item : ResourceItem
const item_detail_ui_pack : PackedScene = preload("res://Scene/UI/item_detail_ui.tscn")

func set_item(_item : ResourceItem):
	item = _item
	texture_rect.texture = _item.small_icon

func _on_texture_rect_gui_input(event):
	if event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var item_ui : ItemDetailUI = item_detail_ui_pack.instantiate() as ItemDetailUI
		if item == null : return
		Hud.add_child(item_ui)
		item_ui.set_item(item.big_icon)
		item_ui.start(item.description)
