extends Enemy
class_name Baguettehemoth

const TURNING_STRENGTH := 0.005
const ANGLE_DIFFERENCE_MARGIN := 0.125

@onready var raysScene: PackedScene = preload("res://vfx_scenes/small_rays.tscn")
@onready var largeFlashScene: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var baguettehemothSpikeScene: PackedScene = preload("res://vfx_scenes/bagettehemoth_spike.tscn")

@onready var blastSound1: AudioStream = preload("res://sounds/explosion6.wav")
@onready var blastSound2: AudioStream = preload("res://sounds/explosion1.wav")
@onready var breakSound: AudioStream = preload("res://sounds/shatter_large.wav")

func _ready() -> void:
	OFF_SCREEN_FRAME_LIMIT = 600
	# shamelessly copypasted from baguette code
	INGAME_SPAWN_AXES = Vector2(800,800)
	spinSpeed = 0 
	canWrap = false 
	global_rotation = direction
	super()


func _physics_process(delta: float) -> void:
	super(delta)
	var playerPos = Global.GAME_MANAGER.get_player_position()
	if playerPos != null:
		var vectorToPlayer: Vector2 = (playerPos as Vector2) - self.global_position
		if(vectorToPlayer.dot(Vector2.from_angle(PI + self.direction)) < 0.0):
			# that is, if player is already behind the enemy
			return
		var targetDirection: float = fmod(PI + vectorToPlayer.angle(), TAU) # negated because direction is inverted in most other enemies (they go from edge to center)
		var angleDiff: float = targetDirection - self.direction
		if angleDiff <= -PI: angleDiff += TAU
		if angleDiff >= PI: angleDiff -= TAU
		if absf(angleDiff) > ANGLE_DIFFERENCE_MARGIN:
			if angleDiff > 0:
				self.direction += TURNING_STRENGTH
			else:
				self.direction -= TURNING_STRENGTH
		self.global_rotation = self.direction
	

func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(raysScene, global_position)
		for i in range(-3, 4):
			var flashPos: Vector2 = global_position + 70*scale.x*i*Vector2.from_angle(direction)
			Global.create_vfx(largeFlashScene, flashPos)
		for i in range(4):
			var spikePos: Vector2 = global_position + scale.x * randf_range(-120,120) * Vector2.from_angle(direction)
			Global.create_vfx(baguettehemothSpikeScene, spikePos)
		_play_sound(blastSound1, true)
		_play_sound(blastSound2)
		_play_sound(breakSound, true, 0.8)
	super()
