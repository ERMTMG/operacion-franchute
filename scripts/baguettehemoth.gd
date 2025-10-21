extends Enemy
class_name Baguettehemoth

const TURNING_STRENGTH = 0.01

@onready var raysScene: PackedScene = preload("res://vfx_scenes/small_rays.tscn")
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var baguettehemothSpikeScene: PackedScene = preload("res://vfx_scenes/bagettehemoth_spike.tscn")

func _ready() -> void:
	# shamelessly copypasted from baguette code
	INGAME_SPAWN_AXES = Vector2(800,800)
	spinSpeed = 0 
	canWrap = false 
	global_rotation = direction
	super()
	

func _physics_process(delta: float) -> void:
	var playerPos = Global.GAME_MANAGER.get_player_position()
	if playerPos != null:
		var vectorToPlayer: Vector2 = (playerPos as Vector2) - self.global_position
		var targetDirection: float = vectorToPlayer.angle()
		var angleDiff: float = targetDirection - direction
		self.direction = move_toward(direction, targetDirection, TURNING_STRENGTH * signf(angleDiff))
		global_rotation = direction
	super(delta)
	

func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(raysScene, global_position)
		for i in range(-3, 4):
			var flashPos: Vector2 = global_position + 70*scale.x*i*Vector2.from_angle(direction)
			Global.create_vfx(largeFlashScene, flashPos)
		for i in range(4):
			var spikePos: Vector2 = global_position + scale.x * randf_range(-120,120) * Vector2.from_angle(direction)
			Global.create_vfx(baguettehemothSpikeScene, spikePos)
	super()
