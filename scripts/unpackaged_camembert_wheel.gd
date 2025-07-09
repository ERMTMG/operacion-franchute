extends Enemy
class_name UnpackagedCamembertWheel

@onready var camembertSliceScene: PackedScene = preload("res://camembert_slice.tscn")
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var raysScene: PackedScene = preload("res://vfx_scenes/small_rays.tscn")

const NUM_SLICES_SPLIT: int = 6
const SLICES_HP: int = 15

func split_into_slices(number, speed, spin, size, hp) -> void:
	_split(camembertSliceScene, number, speed, spin, size, hp)

func die() -> void:
	if !is_queued_for_deletion():
		split_into_slices(NUM_SLICES_SPLIT, 1.333*speed, 0, scale.x, SLICES_HP)
		Global.create_vfx(largeFlashScene, global_position)
		Global.create_vfx(raysScene, global_position)
	super()
