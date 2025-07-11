extends Enemy
class_name PackagedCamembertWheel

@onready var unpackagedCamembertScene: PackedScene = preload("res://camembert_wheel_unpackaged.tscn")
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var paperScrunchScene: PackedScene = preload("res://vfx_scenes/camembert_paper_scrunch.tscn")

func transform_into_unpackaged_wheel(speed: float, spin: float, hp: int) -> void:
	var unpackagedWheel: UnpackagedCamembertWheel = unpackagedCamembertScene.instantiate()
	unpackagedWheel.spawnFromEdge = false
	unpackagedWheel.global_position = global_position
	unpackagedWheel.direction = direction
	unpackagedWheel.scale = scale
	unpackagedWheel.maxHealth = hp
	unpackagedWheel.health = hp
	unpackagedWheel.speed = speed
	unpackagedWheel.spinSpeed = spin
	call_deferred("add_sibling", unpackagedWheel)
	# this is called upon death, so we don't need to call queue_free() 
	# because die() has already done that for us

func die() -> void:
	if !is_queued_for_deletion():
		transform_into_unpackaged_wheel(1.33*speed, 1.5*spinSpeed, 30)
		Global.create_vfx(paperScrunchScene, global_position)
		var largeFlash := largeFlashScene.instantiate() as Sprite2D
		largeFlash.z_index = 2
		Global.create_vfx_from_node(largeFlash, global_position)
	super()
