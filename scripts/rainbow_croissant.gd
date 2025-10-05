extends Enemy
class_name RainbowCroissant

@onready var rainbowChunkScene := preload("res://rainbow_croissant_chunk.tscn")
@onready var largeFlash := preload("res://vfx_scenes/largeflash.tscn")
@onready var colorFlash := preload("res://vfx_scenes/color_flash.tscn")

func split_into_rainbow_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	var spread: float = 2*PI/number
	var colorSpread: float = 1.0 / number
	var initialDir: float = randf_range(0, 2*PI)
	var initialColor: float = randf_range(0, 1);
	for i in range(number):
		var ithEnemy := rainbowChunkScene.instantiate()
		if ithEnemy is RainbowCroissantChunk:
			ithEnemy.speed = speed
			ithEnemy.spinSpeed = spin
			ithEnemy.scale = size*Vector2.ONE
			ithEnemy.maxHealth = hp
			ithEnemy.spawnFromEdge = false
			ithEnemy.global_position = global_position
			ithEnemy.direction = initialDir + i*spread
			ithEnemy.z_index = self.z_index - 1
			ithEnemy.colorHue = initialColor + i * colorSpread
			if ithEnemy.colorHue > 1.0: ithEnemy.colorHue -= 1.0
			call_deferred("add_sibling", ithEnemy)
		else:
			push_error("bruh this ain't an enemy")
			
func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(largeFlash, global_position)
		Global.create_vfx(colorFlash, global_position + Vector2.from_angle(randf() * TAU) * 120 * randf())
		Global.create_vfx(colorFlash, global_position + Vector2.from_angle(randf() * TAU) * 120 * randf())
		Global.create_vfx(colorFlash, global_position + Vector2.from_angle(randf() * TAU) * 120 * randf())
		split_into_rainbow_chunks(randi_range(5,7), 1.5 * speed, spinSpeed, 1.1*scale.x, 15)
	super()
