extends AnimatedSprite2D
@export var MAX_SPEED: float = 5
@export var SPIN_SPEED: float = 0.08
@export var BEGIN_VANISH_FRAME_COUNT: int = 30
@export var END_VANISH_FRAME_COUNT: int = 80
var timer: int = 0
var speed: Vector2
var vanishIncrement: float = 1.0 / (END_VANISH_FRAME_COUNT - BEGIN_VANISH_FRAME_COUNT)

func _ready() -> void:
	var n: int = sprite_frames.get_frame_count(animation)
	frame = randi_range(0, n-1)
	speed = randf()*MAX_SPEED*Vector2.from_angle(randf()*TAU)
	timer = 0


func _physics_process(delta: float) -> void:
	timer += 1
	global_position += speed
	speed *= 0.99
	global_rotation += SPIN_SPEED
	if timer >= BEGIN_VANISH_FRAME_COUNT:
		modulate.a -= vanishIncrement
	if timer >= END_VANISH_FRAME_COUNT:
		queue_free()
