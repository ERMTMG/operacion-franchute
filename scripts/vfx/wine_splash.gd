extends AnimatedSprite2D
@export var BEGIN_VANISH_FRAME_COUNT: int = 140
@export var END_VANISH_FRAME_COUNT: int = 240
const MIN_SIZE: float = 0.95
const MAX_SIZE: float = 1.35
var timer: int = 0
var vanishIncrement: float = 1.0 / (END_VANISH_FRAME_COUNT - BEGIN_VANISH_FRAME_COUNT)
var sizeDecrement: float = 0.0005
var targetSize: float

func _ready() -> void:
	var n: int = sprite_frames.get_frame_count(animation)
	frame = randi_range(0, n-1)
	timer = 0
	modulate = Color.WHITE
	rotation = randf() * TAU
	targetSize = randf_range(MIN_SIZE, MAX_SIZE)
	if !Global.INGAME: targetSize /= 2
	scale = Vector2.ZERO

func _physics_process(delta: float) -> void:
	timer += 1
	if timer < BEGIN_VANISH_FRAME_COUNT:
		scale += 0.5*(targetSize - scale.x)*Vector2.ONE
	if timer >= BEGIN_VANISH_FRAME_COUNT:
		modulate.a -= vanishIncrement
		scale -= sizeDecrement * Vector2.ONE
	if timer >= END_VANISH_FRAME_COUNT:
		queue_free()
