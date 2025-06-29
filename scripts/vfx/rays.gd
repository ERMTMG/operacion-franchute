extends Sprite2D
@export var large: bool
var spin = randf_range(0.005,0.01)
func _ready():
	global_rotation = randf_range(0,2*PI)

func _physics_process(delta):
	if large: modulate.a -= 0.01
	else: modulate.a -= 0.025
	global_rotation += spin
