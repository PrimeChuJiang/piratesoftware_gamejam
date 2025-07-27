extends Room


func _fresh_scene():
	for _child in parallox_layer.get_children():
		if _child is BaseItem2D :
			if _child.type == GameConfigs.interaction_type.item:
				var _visible = AllParams.room_5_param[_child.item_info.name]
				if not _visible: 
					parallox_layer.remove_child(_child)
					_child.done()
			elif _child.type == GameConfigs.interaction_type.npc:
				_child.update_state(AllParams.room_5_param)
