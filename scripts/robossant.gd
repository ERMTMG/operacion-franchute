extends Enemy
class_name Robossant
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var smallFlashScene: PackedScene = preload("res://vfx_scenes/small_flash.tscn")
@onready var robossantPieceScene: PackedScene = preload("res://vfx_scenes/robossant_piece.tscn")
@onready var croissantScene: PackedScene = preload("res://croissant.tscn")

func split_into_croissants(number: int, speed: float, spin: float, size: float, hp: int) -> void:
		_split(croissantScene, number, speed, spin, size, hp)

func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(largeFlashScene, global_position)
		for i in range(3):
			Global.create_vfx(largeFlashScene,
				global_position + randf()*50*Vector2.from_angle(randf()*TAU))
		for i in range(4):
			Global.create_vfx(robossantPieceScene, global_position)
		split_into_croissants(3, speed, spinSpeed, 0.4*scale.x, 10)
	super()
