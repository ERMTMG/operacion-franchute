extends Enemy
class_name RainbowCroissant

@export var laserSpawningPoints: Array[Node2D]

@onready var laserShootSound := preload("res://sounds/enemy_laser.wav")
@onready var rainbowLaserScene := preload("res://rainbow_croissant_laser.tscn")
@onready var rainbowChunkScene := preload("res://rainbow_croissant_chunk.tscn")
@onready var largeFlash := preload("res://vfx_scenes/largeflash.tscn")
@onready var colorFlash := preload("res://vfx_scenes/color_flash.tscn")

@onready var blastSound: AudioStream = preload("res://sounds/explosion7.wav")
@onready var backgroundBlast: AudioStream = preload("res://sounds/explosion4.wav")

var currentLaserSpawnPointIdx: int = 0
var currentLaserColorHue: float = 0.0
var laserColorHueIncrement: float
var laserFrameCounter: int = 0

const LASER_SHOOT_FREQ_FRAMES := 40
const LASER_SPEED := 600.0

func _ready() -> void:
	super()
	laserColorHueIncrement = randf()

func split_into_rainbow_chunks(number: int, speed: float, spin: float, size: float, hp: int) -> void:
	var spread: float = 2*PI/number
	var colorSpread: float = 1.0 / number
	var initialDir: float = randf_range(0, 2*PI)
	var initialColor: float = randf_range(0, 1);
	for i in range(number):
		var ithEnemy := rainbowChunkScene.instantiate()
		if ithEnemy is RainbowCroissantChunk:
			ithEnemy.speed = speed
			ithEnemy.spinSpeed = spin
			ithEnemy.scale = size*Vector2.ONE
			ithEnemy.maxHealth = hp
			ithEnemy.spawnFromEdge = false
			ithEnemy.global_position = global_position
			ithEnemy.direction = initialDir + i*spread
			ithEnemy.z_index = self.z_index - 1
			ithEnemy.colorHue = initialColor + i * colorSpread
			if ithEnemy.colorHue > 1.0: ithEnemy.colorHue -= 1.0
			call_deferred("add_sibling", ithEnemy)
		else:
			push_error("bruh this ain't an enemy")
			
func die() -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(largeFlash, global_position)
		Global.create_vfx(colorFlash, global_position + Vector2.from_angle(randf() * TAU) * 120 * randf())
		Global.create_vfx(colorFlash, global_position + Vector2.from_angle(randf() * TAU) * 120 * randf())
		Global.create_vfx(colorFlash, global_position + Vector2.from_angle(randf() * TAU) * 120 * randf())
		_play_sound(backgroundBlast, false, 1.25)
		_play_sound(blastSound, true)
		split_into_rainbow_chunks(randi_range(5,7), 1.5 * speed, spinSpeed, 1.1*scale.x, 15)
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	laserFrameCounter += 1
	if laserFrameCounter >= LASER_SHOOT_FREQ_FRAMES:
		laserFrameCounter = 0
		shoot_laser()

func shoot_laser() -> void:
	if Global.GAME_MANAGER.get_player_node() == null: return
	var laserSpawnPosition: Vector2 = laserSpawningPoints[currentLaserSpawnPointIdx].global_position
	var playerPosition: Vector2 = Global.GAME_MANAGER.get_player_position() # guaranteed to return non-null because player will exist
	var laserDirection: float = laserSpawnPosition.angle_to_point(playerPosition)
	var laser := rainbowLaserScene.instantiate() as RainbowCroissantLaser
	laser.position = laserSpawnPosition
	laser.direction = laserDirection
	laser.colorHue = currentLaserColorHue
	laser.speed = LASER_SPEED
	laser.z_index = z_index - 1
	call_deferred("add_sibling", laser)
	Global.GAME_MANAGER.play_sfx(laserShootSound, 1.2)
	currentLaserColorHue = fmod(currentLaserColorHue + laserColorHueIncrement, 1.0)
	currentLaserSpawnPointIdx = (currentLaserSpawnPointIdx + 1) % laserSpawningPoints.size()
