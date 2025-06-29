extends Area2D
class_name Enemy

@export_group("Enemy-Specific Properties")
@export var maxHealth: int
var health: int
var offScreenFrames: int
@export var speed: float
@export var spinSpeed: float
@export var direction: float
@export var spawnFromEdge: bool = true

@export_group("Node and Scene Connections")
@export_file var myScenePath: String
@onready var myScene: PackedScene
@export var hpBar: HPBar
@export var flashAnim: AnimationPlayer
@export var sprite: AnimatedSprite2D
@export var visibilityNotifier: VisibleOnScreenNotifier2D


@export_group("Enemy Class Properties")
@export var damage: int
@export var scoreAwarded: int
@export var showHP: bool = true
@export var HP_BAR_POS: int = 100
@export var screenFlashOnDeath: bool
@export var screenShakeOnDeath: bool
@export var deathScreenShakeIntensity: float
@export var deathScreenShakeDuration: int

@export var canWrap: bool = true

var INGAME_SPAWN_AXES: Vector2 = Vector2(900, 600)
var MENU_SPAWN_AXES: Vector2 = Vector2(1200, 900)
const OFF_SCREEN_FRAME_LIMIT: int = 180

var pointedByMouse: bool = false

func _ready() -> void:
	assert(flashAnim.has_animation("RESET") && flashAnim.has_animation("flash"))
	assert(get_parent() is Game)
	myScene = load(myScenePath)
	flashAnim.play("RESET")
	Global.ENEMYCOUNT += 1
	if Global.ENEMYCOUNT > Global.MAXENEMYCOUNT:
		queue_free();
	health = maxHealth
	if !Settings.ENEMY_HP_BARS_ENABLED && hpBar != null:
		hpBar.queue_free()
	if spawnFromEdge:
		offScreenFrames = 0 # fixed?? i think?
		if Global.INGAME:
			global_position = Vector2.from_angle(direction) * INGAME_SPAWN_AXES # component-wise multiplication (convenient, somehow)
		else:
			global_position = Vector2.from_angle(direction) * MENU_SPAWN_AXES
	elif visibilityNotifier.is_on_screen():
		offScreenFrames = -1
	else:
		offScreenFrames = 0
	if sprite.sprite_frames.has_animation("default"): #default animation code: pick a random frame from the "default" animation if it exists
		sprite.animation = "default"
		var max: int = sprite.sprite_frames.get_frame_count("default")
		if max > 1: sprite.frame = randi_range(0, max - 1)
	if !showHP:
		hpBar.hide()

func _split(enemy: PackedScene, number: int, speed: float, spin: float, size: float, hp: int, eraseAfter: bool = false) -> void:
	var spread: float = 2*PI/number
	var initialDir: float = randf_range(0, 2*PI)
	for i in range(number):
		var ithEnemy = enemy.instantiate()
		if ithEnemy is Enemy:
			ithEnemy.speed = speed
			ithEnemy.spinSpeed = spin
			ithEnemy.scale = size*Vector2.ONE
			ithEnemy.maxHealth = hp
			ithEnemy.spawnFromEdge = false
			ithEnemy.global_position = global_position
			ithEnemy.direction = initialDir + i*spread
			call_deferred("add_sibling", ithEnemy)
		else:
			push_error("bruh this ain't an enemy")
	if eraseAfter:
		queue_free()

func _split_ranges(enemy: PackedScene, number: int, 
  speedRange: Array[float], spinRange: Array[float], sizeRange: Array[float], 
  hpRange: Array[int], eraseAfter: bool = false) -> void:
	const MIN: int = 0
	const MAX: int = 1
	
	assert( 
		speedRange.size() == 2 &&
		spinRange.size() == 2 &&
		sizeRange.size() == 2 &&
		hpRange.size() == 2
	)
	var spread: float = 2*PI/number
	var initialDir: float = randf_range(0, 2*PI)
	for i in range(number):
		var ithEnemy = enemy.instantiate()
		if ithEnemy is Enemy:
			ithEnemy.speed = randf_range(speedRange[MIN], speedRange[MAX])
			ithEnemy.spinSpeed = randf_range(spinRange[MIN], spinRange[MAX])
			ithEnemy.scale = randf_range(sizeRange[MIN], sizeRange[MAX])*Vector2.ONE
			ithEnemy.maxHealth = randi_range(hpRange[MIN], hpRange[MAX])
			ithEnemy.spawnFromEdge = false
			ithEnemy.global_position = global_position
			ithEnemy.direction = initialDir + i*spread
			call_deferred("add_sibling", ithEnemy)
		else:
			push_error("bruh this ain't an enemy")
	if eraseAfter:
		queue_free()

func _play_sound(sfx: AudioStream, volume: float = 1.0) -> void:
	(get_parent() as Game).play_sfx(sfx, volume)

func wrap_around() -> void:
	global_position = -global_position
	offScreenFrames = 0

func _set_debug_label(text: String):
	$DEBUG_LABEL.text = text
	$DEBUG_LABEL.global_position = global_position + scale.y * 120 * Vector2.UP
	$DEBUG_LABEL.rotation = -global_rotation

func check_player() -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.hurt(damage)

func hit_by_bullet(bullet: Laser) -> void:
	health -= bullet.damage
	Global.SCORE += 1
	if Settings.ENEMY_FLASH_ENABLED:
		flashAnim.play("flash")
	if health < 1:
		die()
	bullet.hit_enemy()

func die() -> void:
	if !is_queued_for_deletion():
		if Global.INGAME: Global.SCORE += scoreAwarded
		var parent = get_parent()
		if parent is Game:
			if screenFlashOnDeath: parent.screen_flash()
			if screenShakeOnDeath: parent.screen_shake(deathScreenShakeIntensity, deathScreenShakeDuration)
	queue_free()

func _exit_tree() -> void:
	Global.ENEMYCOUNT -= 1

func _physics_process(delta: float) -> void:
	if $DEBUG_LABEL.visible: _set_debug_label("DEBUGGING")
	global_rotation += spinSpeed
	global_position -= speed * Vector2.from_angle(direction)
	check_player()
	if offScreenFrames >= 0:
		offScreenFrames += 1
		if offScreenFrames >= OFF_SCREEN_FRAME_LIMIT:
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	offScreenFrames = -1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if Global.ENEMYCOUNT > Global.MAXENEMYCOUNT || (!canWrap && Global.INGAME):
		queue_free()
	elif canWrap || !Global.INGAME:
		wrap_around()

func _on_body_entered(body: Node2D) -> void:
	if body is Laser && !body.is_queued_for_deletion():
		hit_by_bullet(body)
