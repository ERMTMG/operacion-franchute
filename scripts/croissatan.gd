extends Enemy
class_name Croissatan
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var raysScene: PackedScene = preload("res://vfx_scenes/small_rays.tscn")
@onready var hornScene: PackedScene = null
@onready var satanicChunkScene: PackedScene = null

var chunkShootTimer: int = 0
const CHUNK_SHOOT_TIME_INTERVAL: int = 200
const NUMBER_CHUNKS_SHOT: int = 3

func shoot_out_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	_split(satanicChunkScene, number, speed, spin, size, hp, false)

func _physics_process(delta: float) -> void:
	super(delta)
	chunkShootTimer += 1
	if chunkShootTimer >= CHUNK_SHOOT_TIME_INTERVAL and Global.INGAME:
		shoot_out_chunks(NUMBER_CHUNKS_SHOT, 0.667*speed, 0.9*spinSpeed, 0.5*scale.x, 10)
		chunkShootTimer = 0

func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(largeFlashScene, global_position)
		Global.create_vfx(raysScene, global_position)
		var horn1 := hornScene.instantiate()
		var horn2 := hornScene.instantiate()
		# ... TODO: edit horns
		Global.create_vfx_from_node(horn1, global_position)
		Global.create_vfx_from_node(horn2, global_position)
		shoot_out_chunks(6, 1.333*speed, spinSpeed, 0.5*scale.x, 30)
	super()
