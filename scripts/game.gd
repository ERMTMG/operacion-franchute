extends Node2D
class_name Game
var timer: int = 0
var screentimer: int = 0
var screenshakeduration: int = 0
var screenshakeintensity: float = 0
var ssicap: float = 0
var totalssdur: int = 0
var ingame: bool = true
var blackscreen: bool = false
const DARK_BG: Color = Color("6a6a6a")
const LIGHT_BG: Color = Color.WHITE
const ChanceArray = Utils.ChanceArray
var spawningRules: Dictionary[float, Object]
var spawningTimestampsSorted: Array[float]
const ENEMY_SPAWN_RULES_FILENAME: String = "res://other_data/enemy_camembert_test.json"

#TODO: these variables are temp
var spawnedCroissants: int = 0
var spawnedBaguettes: int = 0
var spawnedRobossants: int = 0

@export var menu: Control 
@export var redCover: ColorRect 
@export var blackCover: ColorRect 
@export var pauseMenuShaderScreen: ColorRect
@export var gameStartButton: GameStartButton
@export var camera: Camera2D
@export var gameTimer: Timer
@export var enemySpawnTimer: Timer
@export var backgroundSprite: AnimatedSprite2D
@export var highScoreScreen: HighScoreScreenClass
@export var offScreenIndicator: Sprite2D
@export var offScreenSound: AudioStreamPlayer
@export var HUD: CanvasLayer
@export var mousePointerCollision: Area2D
@export var basicScoreCounter: Label
@export var fancyScoreCounter: ScoreLabel
@export var beforeQuittingPopup: TextureRect
const PlayerScene: PackedScene = preload("res://player.tscn")

#POWERUPS
var genericPowerup: PackedScene = preload("res://powerup.tscn")
var smallHeart: PackedScene = preload("res://small_heart.tscn")
var largeHeart: PackedScene = preload("res://large_heart.tscn")
var ammoBox: PackedScene = preload("res://ammo_box_powerup.tscn")
var blueLaser: PackedScene = preload("res://blue_laser_powerup.tscn")
var smallMoneybag: PackedScene = preload("res://small_moneybag_powerup.tscn")
var largeMoneybag: PackedScene = preload("res://large_moneybag_powerup.tscn")
#
var playerdamagesignal = Callable(self, "_on_character_body_2d_damaged")
var playerdeadsignal = Callable(self, "_on_character_body_2d_dead")
const PAUSE_SHADER: Shader = preload("res://paused_screen_filter.gdshader")


func r(min: float, max: float) -> float: # Shorthands for enemy spawning
	return randf_range(min,max)
func ri(min: int,max: int) -> int:
	return randi_range(min,max)

func play_sfx(sfx: AudioStream, volume: float = 1.0):
	var stream: AudioSFX = AudioSFX.new()
	stream.stream = sfx
	stream.volume_db = -30 + volume*20
	stream.bus = "sfx"
	stream.connect("finished", Callable(stream, "delete"))
	add_child(stream)
	stream.play()

# finds and returns the first player node in the game.
func get_player_node() -> Player:
	var found: bool =  false
	if !get_children().is_empty():
		for node in get_children():
			if node is Player:
				found = true
				return node as Player
		if !found: return null
	return null

func get_player_position(): # -> Vector2 or null
	if get_player_node() != null:
		return get_player_node().global_position
	else: return null
	
func screen_shake(intensity: float, duration: int):
	if Settings.SCREEN_SHAKE_ENABLED:
		if screenshakeintensity < intensity: screenshakeintensity = intensity
		if screenshakeduration < duration: screenshakeduration = duration
		totalssdur = duration
		ssicap = intensity

func handle_screen_shake():
	if screenshakeduration > 0:
		camera.position = screenshakeintensity*Vector2.from_angle(randf_range(0,2*PI))
		screenshakeintensity *= 2.0*screenshakeduration/totalssdur
		if screenshakeintensity > ssicap: screenshakeintensity = ssicap
		elif screenshakeintensity < 0.01: screenshakeduration = 0
		screenshakeduration -= 1
	else:
		camera.position = Vector2.ZERO

func count_enemies_of_type(EnemyType) -> int:
	var count: int = 0
	for child in get_children():
		if child is Enemy && is_instance_of(child, EnemyType):
			count += 1
	return count

func screen_flash():
	if Settings.SCREEN_FLASH_ENABLED:
		backgroundSprite.modulate = LIGHT_BG
		backgroundSprite.play("flash1")
	

enum Direction {RANDOM = -1, PLAYER = -2}

#region Unused!
func get_enemy(enemy: PackedScene, size: float, hp: int, speed: float, spin: float, direction: float) -> Enemy:
	var enemyNode = enemy.instantiate()
	if enemyNode is Enemy:
		enemyNode.scale = size*Vector2.ONE
		enemyNode.maxHealth = hp
		enemyNode.speed = speed
		enemyNode.spinSpeed = spin
		if direction == Direction.RANDOM:
			enemyNode.direction = r(0, 2*PI)
		elif direction == Direction.PLAYER: # point towards player (or random if player doesn't exist)
			var playerPosition = get_player_position()
			if playerPosition == null:
				enemyNode.direction = r(0, 2*PI)
			else:
				assert(playerPosition is Vector2)
				enemyNode.direction = (-playerPosition).angle()
		else: enemyNode.direction = direction
		return enemyNode
	else:
		return null

func spawn_enemy(enemy: PackedScene, size: float, hp: int, speed: float, spin: float, direction: float) -> void:
	var enemyNode = enemy.instantiate()
	if enemyNode is Enemy:
		enemyNode.scale = size*Vector2.ONE
		enemyNode.maxHealth = hp
		enemyNode.speed = speed
		enemyNode.spinSpeed = spin
		if direction == Direction.RANDOM:
			enemyNode.direction = r(0, 2*PI)
		elif direction == Direction.PLAYER: # point towards player (or random if player doesn't exist)
			var playerPosition = get_player_position()
			if playerPosition == null:
				enemyNode.direction = r(0, 2*PI)
			else:
				assert(playerPosition is Vector2)
				enemyNode.direction = (-playerPosition).angle()
		else: enemyNode.direction = direction
		add_child(enemyNode)
#endregion

func init_enemy_spawning_rules() -> void:
	var intervals = EnemyJSON.parse_enemy_spawning_rules_from_json_file(
		ENEMY_SPAWN_RULES_FILENAME
	)
	if intervals is Dictionary:
		spawningRules = intervals
		spawningTimestampsSorted = spawningRules.keys()
		spawningTimestampsSorted.sort()

func get_powerup(powerUp: PackedScene) -> PowerUp:
	var powerUpNode = powerUp.instantiate()
	if powerUpNode is PowerUp:
		return powerUpNode
	else:
		return null

func spawn_powerup(powerUp: PackedScene) -> void:
	var powerUpNode = powerUp.instantiate()
	if powerUpNode is PowerUp:
		add_child(powerUpNode)

func spawn_small_heart() -> void:
	spawn_powerup(smallHeart)

func spawn_large_heart() -> void:
	spawn_powerup(largeHeart)

func spawn_ammo_box() -> void:
	spawn_powerup(ammoBox)

func spawn_blue_laser_beam() -> void:
	spawn_powerup(blueLaser)

func _ready():
	Global.GAME_MANAGER = self
	menu.show()
	backgroundSprite.modulate = DARK_BG
	Global.PLAYERHEALTH = 100
	Global.PLAYERMAXHEALTH = 100
	init_enemy_spawning_rules()
	enemySpawnTimer.start(r(2.0,4.0))
	


func start_game():
	if(Settings.PAUSE_SCREEN_FILTER_ENABLED):
		(pauseMenuShaderScreen.material as ShaderMaterial).shader = PAUSE_SHADER
		pauseMenuShaderScreen.show()
	else:
		(pauseMenuShaderScreen.material as ShaderMaterial).shader = null
		pauseMenuShaderScreen.hide()
	
	if Settings.FANCY_SCORE_COUNTER_ENABLED:
		fancyScoreCounter.show()
		fancyScoreCounter.effect_enabled = false
		basicScoreCounter.hide()
	else:
		fancyScoreCounter.hide()
		basicScoreCounter.show()
	for node in get_children():
		if node is Enemy:
			node.queue_free()
	var playernode = PlayerScene.instantiate()
	playernode.connect("damaged", playerdamagesignal)
	playernode.connect("dead", playerdeadsignal)
	add_child(playernode)
	Global.INGAME = true
	Global.GAMETIME = 0
	Global.SCORE = 0
	gameTimer.start()
	enemySpawnTimer.start(r(0,1.0))

func unfade_and_start():
	blackscreen = false
	menu.visible = false
	start_game()

func spawn_enemies(time: float):
	var gameTime := Global.GAMETIME
	for timestamp in spawningTimestampsSorted:
		if timestamp as float > gameTime:
			var currentRule := spawningRules[timestamp]
			var spawn: EnemySpawner.EnemySpawn
			if currentRule is Utils.ChanceArray:
				spawn = EnemySpawner.\
				  get_enemy_spawn_from_enemy_spawning_chance_array(currentRule)
			else:
				spawn = currentRule
			spawn.spawn_as_child_of(self)
			break # only spawn from the lowest upper bound!

func handle_offscreen_player_warning() -> void:
	var player: Player = get_player_node()
	if player != null && player.is_off_screen() && Global.INGAME:
		offScreenIndicator.visible = true
		var playerScreenPosition: Vector2 = player.get_global_transform_with_canvas().origin
		offScreenIndicator.position = Vector2.ZERO
		offScreenIndicator.rotation = (playerScreenPosition - offScreenIndicator.global_position).angle()
		offScreenIndicator.position = (playerScreenPosition - offScreenIndicator.global_position)*0.75
	
		if !offScreenSound.playing: offScreenSound.play()
	else:
		offScreenIndicator.visible = false
		if offScreenSound.playing: offScreenSound.stop()



func spawn_powerups(time: float):
	if randi() % 300 == 0:
		spawn_powerup(smallMoneybag)
	if randi() % 301 == 0:
		spawn_powerup(largeMoneybag)
	"""if time < 60:
		if randi() % 600 == 0:
			spawn_ammo_box()
	elif time >= 60:
		var healthratio = 1.0*Global.PLAYERHEALTH / Global.PLAYERMAXHEALTH
		if healthratio < 0.5:
			if randi() % 500 == 0:
				if randi() % 5 == 0: spawn_large_heart()
				else: spawn_small_heart()"""

func _on_loaded_data():
	highScoreScreen.update_high_score()
	if Global.HIGH_SCORE > 0: highScoreScreen.show_on_menu()

func fade_in_menu():
	gameStartButton.moveup()
	menu.modulate.a = 0.0
	menu.visible = true
	if Global.HIGH_SCORE > 0:
		highScoreScreen.show_on_menu()

func _physics_process(delta: float) -> void:
	timer += 1
	Global.update(delta)
	spawn_powerups(Global.GAMETIME)
	if screentimer >= 0: screentimer -= 1
	else: redCover.visible = false
	handle_screen_shake()
	for child in get_children():
		if child is AudioSFX and !child.playing:
			child.queue_free()
	backgroundSprite.scale = 0.47/(camera.zoom.x + 0.33)*Vector2.ONE
	if Global.INGAME == false:
		offScreenIndicator.visible = false
		if offScreenSound.playing: offScreenSound.stop()
		if menu.modulate.a != 1.0:
			menu.modulate.a = move_toward(menu.modulate.a, 1.0,0.05)
		camera.zoom.x += (0.66 - camera.zoom.x)*0.01
	else:
		if Settings.FANCY_SCORE_COUNTER_ENABLED && !fancyScoreCounter.effect_enabled:
			fancyScoreCounter.effect_enabled = true
		handle_offscreen_player_warning()
		camera.zoom.x += (1.33 - camera.zoom.x)*0.1
	if blackscreen:
		blackCover.visible = true
		blackCover.modulate.a = move_toward(blackCover.modulate.a, 1.0, 0.02)
		if blackCover.modulate.a == 1.0: unfade_and_start()
	else:
		blackCover.modulate.a = move_toward(blackCover.modulate.a, 0.0, 0.02)
		if blackCover.modulate.a == 0.0: blackCover.visible = false
	mousePointerCollision.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("mouse click") && !Global.INGAME \
	   && Global.CURRENT_MENU_SHOWING == Global.NONE:
		for child in get_children():
			if child is Enemy:
				var enemy: Enemy = child as Enemy
				if mousePointerCollision in enemy.get_overlapping_areas():
					enemy.die()

func _on_bg_animation_finished():
	backgroundSprite.modulate = DARK_BG

func _on_character_body_2d_damaged():
	screen_shake(10,30)
	if Settings.SCREEN_FLASH_ENABLED:
		redCover.visible = true
		screentimer = 2
	
func _on_character_body_2d_dead():
	Global.reset_buffs()
	$MenuTimer.start()
	gameTimer.stop()
	for node in get_children():
		if node is Enemy: 
			node.die()
	if Global.check_high_score():
		highScoreScreen.update_high_score()
	Global.INGAME = false

func _on_game_timer_timeout():
	Global.GAMETIME += 0.1
	gameTimer.start()
	
func _on_enemy_timer_timeout():
	spawn_enemies(Global.GAMETIME)
	enemySpawnTimer.start(r(3,4))

func _on_button_button_down():
	blackscreen = true
	highScoreScreen.hide_from_menu()

func _on_menu_timer_timeout():
	fade_in_menu()

func kill_player() -> void:
	var player: Player = get_player_node()
	if player.deathTimer == player.NOT_DEAD:
		player.die()

func get_foreground_layer() -> CanvasLayer:
	return HUD

func ask_save_confirmation_before_quitting() -> void:
	beforeQuittingPopup.menuToComeBackTo = Global.CURRENT_MENU_SHOWING
	beforeQuittingPopup.show()
	Global.CURRENT_MENU_SHOWING = Global.BEFORE_QUIT_POPUP
