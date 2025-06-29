extends Sprite2D

@export var BEGIN_VANISH_FRAME_COUNT: int = 30
@export var END_VANISH_FRAME_COUNT: int = 55
@export var Y_SPEED: float = 0.3

var timer: int = 0
var vanishIncrement: float = 1.0 / (END_VANISH_FRAME_COUNT - BEGIN_VANISH_FRAME_COUNT)

func _physics_process(delta: float) -> void:
	timer += 1
	global_position += Y_SPEED*Vector2.UP
	if timer >= BEGIN_VANISH_FRAME_COUNT:
		modulate.a -= vanishIncrement
	if timer >= END_VANISH_FRAME_COUNT:
		queue_free()
