extends CharacterBody2D

class_name Player
const SCREEN_MARGIN_RATIO: float = 0.9 
const ACCEL: float = 50
const DAMP: float = 0.93
const FIRST_HIT_BONUS_MULTIPLIER: float = 2
const NOTIFICATION_OFFSET: int = 25
@onready var redLaser: PackedScene = preload("res://red_laser.tscn")
@onready var blueLaser: PackedScene = preload("res://blue_laser.tscn")
@onready var smoke: PackedScene = preload("res://vfx_scenes/smoke.tscn")
@onready var smallFlash: PackedScene = preload("res://vfx_scenes/small_flash.tscn")
@onready var rays: PackedScene = preload("res://vfx_scenes/large_rays.tscn")
static var firstHitBonusNotif: PackedScene = preload("res://vfx_scenes/first_hit_bonus_notif.tscn")
@export var firingSound: AudioStreamPlayer 
@export var fireSprite: AnimatedSprite2D
@export var otherSFX: AudioStreamPlayer
@export var hitBox: CollisionPolygon2D
@export var sprite: Sprite2D
@export var spriteSparkleEffect: GPUParticles2D
static var powerUpSound: AudioStream = preload("res://sounds/powerup.wav")
const moneyClink: AudioStream = preload("res://sounds/cling.wav")
const explosions: Array[AudioStream] = [preload("res://sounds/explosion01.wav"),preload("res://sounds/explosion02.wav"),preload("res://sounds/explosion03.wav"),preload("res://sounds/explosion04.wav")]
const redLaserFireSound: AudioStream = preload("res://sounds/laser.wav")
const blueLaserFireSound: AudioStream = preload("res://sounds/laser_blue.mp3")
const bigboomsound: = preload("res://sounds/explosion06.wav")
const backgroundboom = preload("res://sounds/explosion05.wav")
var xinput: float = 0
var yinput: float = 0
var firetimer: int = 0
var hurttimer: int = 0
var maxhp: int = 100
var hp: int = maxhp
var frame: int = 0
var deathTimer: int = NOT_DEAD
var untouched: bool
enum {NOT_DEAD = -1}
var INSCREEN_RECT: Rect2
signal damaged
signal dead

func _ready():
	INSCREEN_RECT = get_viewport_rect()
	INSCREEN_RECT.position += INSCREEN_RECT.size * (1 - SCREEN_MARGIN_RATIO) / 2
	INSCREEN_RECT.size *= SCREEN_MARGIN_RATIO
	#print(INSCREEN_RECT)
	
	sprite.texture = PlayerSkins.get_skin_texture(PlayerSkins.CURRENT_PLAYER_SKIN)
	global_position = Vector2.ZERO
	untouched = true;
	deathTimer = NOT_DEAD

func handle_player_movement(joyX: float, joyY: float):
	velocity += ACCEL*Vector2(joyX, joyY)
	velocity *= DAMP
	
	move_and_slide()

func handle_player_animation() -> void:
	if velocity.length() > 100:
		fireSprite.visible = true
		fireSprite.animation = "on"
		if frame % 8 == 0:
			var smokePos: Vector2 = global_position - 20*Vector2.from_angle(global_rotation)
			smokePos += Vector2(randf_range(-15,5),randi_range(-5,5)).rotated(global_rotation)
			Global.create_vfx(smoke, smokePos)
			frame = 0
		if frame % 2 == 0:
			fireSprite.frame = randi_range(0,3)
	else:
		fireSprite.animation = "off"
		fireSprite.visible = false
	spriteSparkleEffect.emitting = PlayerSkins.is_skin_sparkle(PlayerSkins.CURRENT_PLAYER_SKIN)

func spawn_laser(direction: float):
	var laserNode: Laser 
	if Global.get_buff_time(Global.BuffTypes.BLUE_LASER_BUFF) == 0:
		laserNode = redLaser.instantiate()
	else:
		laserNode = blueLaser.instantiate()
	laserNode.direction = direction
	laserNode.global_position = global_position
	add_sibling(laserNode)
	firingSound.play()

func is_off_screen() -> bool:
	var screenPos: Vector2 = get_global_transform_with_canvas().origin
	if !INSCREEN_RECT.has_point(screenPos):
		return true
	else:
		return false


func handle_player_shooting():
	if Input.is_action_just_pressed("shoot"): firetimer = 0
	if Input.is_action_pressed("shoot"):
		if firetimer != 0:
			firetimer -= 1
		else:
			var spread: float
			if Global.get_buff_time(Global.BuffTypes.AMMO_BUFF) == 0:
				firetimer = 3
				spread = 0.2
			else:
				firetimer = 1
				spread = 0.1
			spawn_laser(rotation + randf_range(-spread, spread))
			

func manage_first_hit_bonus() -> void:
	Global.SCORE *= FIRST_HIT_BONUS_MULTIPLIER
	Global.GAME_MANAGER.play_sfx(powerUpSound)
	Global.create_vfx(firstHitBonusNotif, 
		global_position + NOTIFICATION_OFFSET*Vector2.UP, false, true)
	

func hurt(damage: int, instant: bool = false):
	if hurttimer == 0 or instant:
		if untouched:
			untouched = false
			manage_first_hit_bonus()
		hurttimer = randi_range(12,17)
		damage += randi_range(-2,2)
		if damage < 1: damage = 1
		hp -= damage
		Global.GAME_MANAGER.play_sfx(explosions.pick_random())
		damaged.emit()
		if hp <= 0: 
			hp = 0
			die()

func die():
	Global.PLAYERHEALTH = 0 
	Global.PLAYERMAXHEALTH = maxhp
	hitBox.set_deferred("disabled", true)
	deathTimer = 120
	if get_parent() is Game: get_parent().screen_shake(10, 200)

func collect_powerup(powerUp: PowerUp) -> void:
	# print("collected powerup ", powerUp.to_string())
	if powerUp is HealthPowerUp:
		Global.GAME_MANAGER.play_sfx(powerUpSound)
		var addedHealth: int = powerUp.healthGiven
		heal(addedHealth)
	elif powerUp is BuffPowerUp:
		Global.GAME_MANAGER.play_sfx(powerUpSound)
		var frames: int = powerUp.buffTime
		var type: Global.BuffTypes = powerUp.buffType
		Global.set_buff_time(type, frames)
	elif powerUp is PointsPowerUp:
		Global.GAME_MANAGER.play_sfx(powerUpSound)
		Global.GAME_MANAGER.play_sfx(moneyClink)
		Global.SCORE += powerUp.pointsGiven

func heal(addedHealth: int) -> void:
	hp += addedHealth
	if hp > maxhp:
		hp = maxhp

func update_timers_and_variables() -> void:
	frame += 1
	if hurttimer > 0: hurttimer -= 1
	Global.PLAYERHEALTH = hp 
	Global.PLAYERMAXHEALTH = maxhp
	xinput = Input.get_axis("left", "right")
	yinput = Input.get_axis("up", "down")
	if Global.get_buff_time(Global.BuffTypes.BLUE_LASER_BUFF) > 0:
		firingSound.stream = blueLaserFireSound
	else:
		firingSound.stream = redLaserFireSound

func handle_death_animation() -> void:
	fireSprite.visible = false
	deathTimer -= 1
	if deathTimer % 10 == 0: 
		get_parent().play_sfx(explosions.pick_random())
		Global.create_vfx(smallFlash, global_position + randi_range(0,100)*Vector2.from_angle(2*PI*randf()))
	if deathTimer % 3 == 0:
		sprite.position = randi_range(5,10)*Vector2.from_angle(randf_range(0,TAU))

func explode_after_death() -> void:
	var parent: Game = get_parent() as Game
	parent.screen_flash()
	parent.screen_shake(20,60)
	parent.play_sfx(bigboomsound)
	parent.play_sfx(backgroundboom)
	Global.create_vfx(rays, global_position)
	dead.emit()
	queue_free()

func _physics_process(delta):
	update_timers_and_variables()
	if deathTimer == NOT_DEAD:
		handle_player_movement(xinput, yinput)
		handle_player_animation()
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		var cameraPos: Vector2 = get_global_transform_with_canvas().origin
		rotation = (mousePos - cameraPos).angle()
		handle_player_shooting()
	elif deathTimer > 0: 
		handle_death_animation()
	elif deathTimer == 0: # that fucker's finally dead
		explode_after_death()
