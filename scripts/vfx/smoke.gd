extends Sprite2D
var fade = randf_range(0.02,0.05)
func _ready():
	var s = randf_range(0.1,0.2)
	scale = s*Vector2.ONE

func _physics_process(delta):
	modulate.a -= fade
	if modulate.a <= 0.01: queue_free()
