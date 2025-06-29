extends Sprite2D
@export var BEGIN_VANISH_FRAME_COUNT: int = 20
@export var END_VANISH_FRAME_COUNT: int = 100
@export var MIN_SPEED: float = 0.0
@export var MAX_SPEED: float = 1.5
@export var SIZE_MIN: float = 0.150
@export var SIZE_MAX: float = 0.251
const SPIN_SPEED: float = 0.002
const DECELERATION_FACTOR: float = 0.99

var timer: int = 0
var speed: Vector2
var vanishIncrement: float = 1.0 / (END_VANISH_FRAME_COUNT - BEGIN_VANISH_FRAME_COUNT)

func _ready() -> void:
	var color: Color = Color.from_hsv(randf(), 1.0, 1.0)
	var lightness: float = randf_range(1.0, 1.5)
	color.r *= lightness; color.g *= lightness; color.b *= lightness
	color += Color(1.0, 1.0, 1.0, 0.0)
	modulate = color
	speed = randf_range(MIN_SPEED, MAX_SPEED) * Vector2.from_angle(randf() * TAU)
	scale = randf_range(SIZE_MIN, SIZE_MAX) * Vector2.ONE
	rotation = randf() * TAU

func _physics_process(delta: float) -> void:
	timer += 1
	global_position += speed
	speed *= DECELERATION_FACTOR
	rotation += SPIN_SPEED
	if timer >= BEGIN_VANISH_FRAME_COUNT:
		modulate.a -= vanishIncrement
	if timer >= END_VANISH_FRAME_COUNT:
		queue_free()
