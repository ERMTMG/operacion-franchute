extends Enemy
class_name Croissatan
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var raysScene: PackedScene = preload("res://vfx_scenes/small_rays.tscn")
@onready var hornScene: PackedScene = preload("res://vfx_scenes/croissatan_horn_piece.tscn")
@onready var satanicChunkScene: PackedScene = preload("res://satanic_croissant_chunk.tscn")

@onready var backgroundBlast: AudioStream = preload("res://sounds/explosion4.wav")
@onready var blastSound: AudioStream = preload("res://sounds/explosion1.wav")

var chunkShootTimer: int = 0
const CHUNK_SHOOT_TIME_INTERVAL: int = 200
const NUMBER_CHUNKS_SHOT: int = 3
const MAX_TOTAL_CHUNKS: int = 20

func shoot_out_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	_split(satanicChunkScene, number, speed, spin, size, hp, false)

func _physics_process(delta: float) -> void:
	super(delta)
	chunkShootTimer += 1
	if chunkShootTimer >= CHUNK_SHOOT_TIME_INTERVAL \
	and Global.INGAME \
	and Global.GAME_MANAGER.count_enemies_of_type(SatanicCroissantChunk) < MAX_TOTAL_CHUNKS\
	and !is_queued_for_deletion():
		shoot_out_chunks(NUMBER_CHUNKS_SHOT, 0.667*speed, 0.9*spinSpeed, scale.x, 4)
		chunkShootTimer = 0

func die(_omitSignal: bool = false) -> void:
	if !is_queued_for_deletion():
		_play_sound(backgroundBlast, false, 1.25)
		_play_sound(blastSound, true)
		Global.create_vfx(largeFlashScene, global_position)
		Global.create_vfx(raysScene, global_position)
		var horn1 := hornScene.instantiate()
		var horn2 := hornScene.instantiate()
		if horn1 is AnimatedSprite2D && horn2 is AnimatedSprite2D:
			(horn1 as AnimatedSprite2D).frame = 0
			(horn2 as AnimatedSprite2D).frame = 1
		Global.create_vfx_from_node(horn1 as AnimatedSprite2D, global_position)
		Global.create_vfx_from_node(horn2 as AnimatedSprite2D, global_position)
		shoot_out_chunks(6, 1.333*speed, spinSpeed, scale.x, 5)
	super(_omitSignal)
