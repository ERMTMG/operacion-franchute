extends Enemy
class_name Baguette

@onready var raysScene = preload("res://vfx_scenes/small_rays.tscn")
@onready var largeFlashScene = preload("res://vfx_scenes/largeflash.tscn")

func _ready() -> void:
	INGAME_SPAWN_AXES = Vector2(800,800)
	spinSpeed = 0 #baguettes don't spin, silly!
	canWrap = false # they don't wrap either do they?
	global_rotation = direction
	super()

func wrap_around() -> void:
	var factor: int = 1
	if randi() % 2 == 0: factor = -1
	global_position = -global_position \
		+ randi_range(50, 100) * Vector2.from_angle(direction + factor*PI/2) #lateral displacement

func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(raysScene, global_position)
		for i in range(-3, 4):
			var flashPos: Vector2 = global_position + 70*scale.x*i*Vector2.from_angle(direction)
			Global.create_vfx(largeFlashScene, flashPos)
	super()
