extends Area3D

class_name InteractionComp

@export var parent_actor : BaseActor
@export var interaction_type : GameConfigs.interaction_type

signal on_interacted

# Called when the node enters the scene tree for the first time.
func _ready():
	match interaction_type:
		GameConfigs.interaction_type.item:
			input_ray_pickable = true
			collision_layer = 0
			collision_mask = 0
		GameConfigs.interaction_type.mechanism:
			input_ray_pickable = false
			collision_layer = 2
			collision_mask = 2

func on_interact():
	on_interacted.emit()
