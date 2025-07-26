extends BaseActor

class_name Base3DSprite

var out_line_tweener : Tween

@onready var sprite_3d = $Sprite3D

var hovering : bool = false:
	set(value):
		hovering = value
		if out_line_tweener and out_line_tweener.is_running():
			out_line_tweener.kill()
		out_line_tweener = create_tween()
		if hovering : 
			out_line_tweener.tween_property(sprite_3d, "out_line_len", 5.0, 0.5)
		else:
			out_line_tweener.tween_property(sprite_3d, "out_line_len", 0.0, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
