extends EnemyProjectile
class_name RainbowCroissantLaser

@export var colorHue: float

func _ready() -> void:
	modulate = Color.from_hsv(colorHue, 1.0, 1.2)
