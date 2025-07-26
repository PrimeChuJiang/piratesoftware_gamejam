extends BaseActor

class_name Door

@onready var animation_player = $AnimationPlayer
@onready var phantom = $PhantomCamera3D
@onready var interact_ui : PackedScene = preload("res://Scene/UI/interact_ui.tscn")

var interactionUI : InteractionUI = null

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# 玩家触发时调用
func _on_entered():
	print("door _on_enter")
	var ui_scene : InteractionUI = interact_ui.instantiate() as InteractionUI
	ui_scene._owner = self
	ui_scene.marker = $Marker3D
	interactionUI = ui_scene
	Hud.add_child(ui_scene)

func _on_leave():
	print("door _on_leave")
	if interactionUI != null:
		Hud.remove_child(interactionUI)
		interactionUI.queue_free()
		interactionUI = null

func _quit_door(_player: Player):
	animation_player.play("close")
	await animation_player.animation_finished
	_player.move_able = true
	phantom.priority = 1
	interaction_component.monitorable = true
	interaction_component.monitorable = true

func open_door():
	# 播放动画
	animation_player.play("open")
	# 提高相机优先级
	phantom.priority = 11
	interaction_component.monitorable = false
	interaction_component.monitorable = false

#func _input(event: InputEvent):
	#if event.is_action_pressed("Space"):
		#match phantom.priority:
			#11:
				#phantom.priority = 1
				#animation_player.play("close")
			#1:
				#phantom.priority = 11
				#animation_player.play("open")
