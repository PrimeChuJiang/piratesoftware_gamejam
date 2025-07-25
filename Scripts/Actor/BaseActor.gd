extends Node3D

class_name BaseActor

@export var can_collect : bool
@export var item : ResourceItem

@onready var interaction_component : InteractionComp = $InteractionComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_component.on_area_entered.connect(_on_entered)
	interaction_component.on_area_leave.connect(_on_leave)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 玩家进行交互时调用
func _on_entered():
	pass

func _on_leave():
	pass
