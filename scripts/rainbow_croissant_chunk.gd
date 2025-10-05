extends CroissantChunk
class_name RainbowCroissantChunk

@export_range(0,1,0.01) var colorHue: float

func split_into_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	var spread: float = 2*PI/number
	var initialDir: float = randf_range(0, 2*PI)
	for i in range(number):
		var ithEnemy := myScene.instantiate()
		if ithEnemy is RainbowCroissantChunk:
			ithEnemy.speed = speed
			ithEnemy.spinSpeed = spin
			ithEnemy.scale = size*Vector2.ONE
			ithEnemy.maxHealth = hp
			ithEnemy.spawnFromEdge = false
			ithEnemy.global_position = global_position
			ithEnemy.direction = initialDir + i*spread
			ithEnemy.z_index = self.z_index - 1
			ithEnemy.colorHue = self.colorHue
			call_deferred("add_sibling", ithEnemy)
		else:
			push_error("bruh this ain't an enemy")

func _ready() -> void:
	super()
	modulate = Color.from_hsv(colorHue, 1.0, 1.0);
