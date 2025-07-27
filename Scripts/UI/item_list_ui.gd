extends Control

class_name ItemListUI

@onready var list_container : VBoxContainer = %list_conatiner

const item_ui_packed : PackedScene = preload("res://Scene/UI/item_ui.tscn")

func _fresh_list(list:Array[ResourceItem]):
	for node in list_container.get_children():
		list_container.remove_child(node)
		node.queue_free()
	for item_res in list:
		var item_scene : ItemUI = item_ui_packed.instantiate()
		list_container.add_child(item_scene)
		item_scene.set_item(item_res)

func remove_item(_item : ResourceItem):
	for node in list_container.get_children() :
		if node is ItemUI and node.item == _item:
			list_container.remove_child(node)
			node.queue_free()

func add_item(_item : ResourceItem):
	var item_scene : ItemUI = item_ui_packed.instantiate()
	list_container.add_child(item_scene)
	item_scene.set_item(_item)
