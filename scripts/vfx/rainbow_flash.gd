extends Sprite2D

@export var FADE_TIME_FRAMES: int = 40

var alphaDecrement: float
var sizeDecrement: float
var currentSize: float

func _ready() -> void:
	modulate = Color.from_hsv(randf(), 1.0, 1.0, 1.0)
	alphaDecrement = 1.0 / FADE_TIME_FRAMES
	currentSize = scale.x
	sizeDecrement = currentSize / (2 * FADE_TIME_FRAMES)

func _physics_process(delta: float) -> void:
	modulate.a -= alphaDecrement
	
