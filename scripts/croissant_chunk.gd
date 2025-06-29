extends Enemy
class_name CroissantChunk
@onready var smallFlashScene: PackedScene = preload("res://vfx_scenes/small_flash.tscn")
const MIN_SCALE: float = 0.75
const BIG_CHUNK_SCORE: int = 25
const SMALL_CHUNK_SCORE: int = 5

func split_into_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	_split(myScene, number, speed, spin, size, hp, false)
	

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	super()
	canWrap = (scale.x > MIN_SCALE)

func _ready() -> void:
	if scale.x > MIN_SCALE: scoreAwarded = BIG_CHUNK_SCORE
	else: scoreAwarded = SMALL_CHUNK_SCORE
	super()

func die() -> void:
	if !is_queued_for_deletion():
		var childrenHP: int = 1
		if scale.x > MIN_SCALE: 
			childrenHP = 2
			split_into_chunks(3, 1.5*speed, 1.5*spinSpeed, 0.5*scale.x, childrenHP)
		Global.create_vfx(smallFlashScene, global_position)
	super()
	
	
