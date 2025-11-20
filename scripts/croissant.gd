extends Enemy
class_name Croissant

@onready var blastSound: AudioStream = preload("res://sounds/explosion1.wav")
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var croissantChunkScene: PackedScene = preload("res://croissant_chunk.tscn")

func split_into_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	_split(croissantChunkScene, number, speed, spin, size, hp)

func die() -> void:
	if !is_queued_for_deletion():
		_play_sound(blastSound, true)
		Global.create_vfx(largeFlashScene, global_position)
		split_into_chunks(randi_range(3,6), 1.25*speed, 1.2*spinSpeed, scale.x, 5)
	super()

func _exit_tree() -> void:
	super()
	print("croissant out!")
