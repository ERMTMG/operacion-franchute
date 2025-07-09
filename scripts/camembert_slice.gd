extends Enemy
class_name CamembertSlice

@onready var smallFlashScene: PackedScene = preload("res://vfx_scenes/small_flash.tscn")
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")

const NUM_SMALL_FLASH_FX_SPAWNED: int = 3
const SMALL_FLASH_FX_MAX_DISTANCE: float = 30.0
const LARGE_FLASH_SCALE_FACTOR: float = 0.8

func _ready() -> void:
	spinSpeed = 0 # slices don't spin, they shoot straight
	global_rotation = direction
	canWrap = 0 # they don't wrap either
	super()

func die() -> void:
	if !is_queued_for_deletion():
		var largeFlash := largeFlashScene.instantiate() as Sprite2D
		largeFlash.scale = LARGE_FLASH_SCALE_FACTOR * Vector2.ONE
		Global.create_vfx_from_node(largeFlash, global_position)
		for i in NUM_SMALL_FLASH_FX_SPAWNED:
			var flashPos := randf() * SMALL_FLASH_FX_MAX_DISTANCE \
				* Vector2.from_angle(randf() * TAU)
			Global.create_vfx(smallFlashScene, flashPos + global_position)
	super()
