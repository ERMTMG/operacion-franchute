extends Sprite2D

func _ready():
	modulate = Color(2,2,2,1)

func _physics_process(delta):
	modulate = modulate - Color(0.15,0.15,0.15,0.05)
	if modulate.a < 0.1: queue_free()
