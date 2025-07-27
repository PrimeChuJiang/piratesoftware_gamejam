extends BaseItem2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click()->void:
	var item_ui : ItemDetailUI = item_detail_ui_pack.instantiate() as ItemDetailUI
	Hud.add_child(item_ui)
	item_ui.set_item(item_info.big_icon)
	item_ui.start(item_info.description)
	Hud.get_node("ItemListUI").add_item(item_info)
	AllParams.room_5_param[item_info.name] = false
	done()

func done() ->void:
	queue_free()
