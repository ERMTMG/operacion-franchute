extends Area2D
class_name PowerUp

@export_group("Node and Scene Connections")
@export var glowSprite: Sprite2D
@export var animPlayer: AnimationPlayer
@export_file var myScenePath: String
var myScene: PackedScene
@export_group("Powerup Class Properties")
@export var movementSpeed: float = 2.0
@export var turningStrength: float = 0.033

var direction: float
var constant_turn: float = 0
const TURN_CHANGE_RARITY = 30
const RANGE: int = 500
var constRandomPosition: Vector2
enum {FOLLOW_PLAYER , MOVE_AROUND_ON_CENTER} # Movement Modes
var movementMode: int # i wish enums counted as types
var framesOffScreen: int = 0
const COLOR_CHANGE_MULTIPLIER: float = 0.01
const CENTER_DISTANCE_LIMIT: float = 300.0
const PLAYER_DISTANCE_LIMIT: float = 100.0
const OFF_SCREEN_FRAME_LIMIT: int = 600

var INGAME_SPAWN_AXES: Vector2 = Vector2(1000, 1000)
var MENU_SPAWN_AXES: Vector2 = Vector2(1450, 1450)

func _ready() -> void:
	myScene = load(myScenePath)
	Global.POWERUPCOUNT += 1
	if Global.POWERUPCOUNT > Global.MAXPOWERUPCOUNT:
		queue_free()
	var initialDirection: float = randf_range(0, 2*PI)
	if Global.INGAME:
		global_position = INGAME_SPAWN_AXES * Vector2.from_angle(initialDirection) # component-wise multiplication (convenient, somehow)
	else:
		global_position = MENU_SPAWN_AXES * Vector2.from_angle(initialDirection)
	direction = -initialDirection
	movementMode = FOLLOW_PLAYER
	if animPlayer.has_animation("pulse"): # initialize default pulse animation
		animPlayer.play("pulse")

func _reroll_random_position() -> void:
	constRandomPosition = Vector2(randi_range(-RANGE, RANGE), randi_range(-RANGE, RANGE))

func _turn_towards(targetDirection: float) -> void:
	direction = move_toward(direction, targetDirection, turningStrength)

func get_player_position() -> Vector2:
	if get_parent() is Game:
		var game: Game = get_parent()
		var returnedPos = game.get_player_position()
		if returnedPos != null && returnedPos is Vector2:
			return returnedPos
	return constRandomPosition # returned if any of the other checks fail

func handle_movement() -> void:
	var smallRandomRange: float = 2*randf_range(-1, 1)
	match movementMode:
		FOLLOW_PLAYER:
			var distanceToPlayer: Vector2 = get_player_position() - global_position
			if distanceToPlayer.length() < PLAYER_DISTANCE_LIMIT:
				_reroll_random_position()
			_turn_towards(distanceToPlayer.angle())
			direction += smallRandomRange * turningStrength
		MOVE_AROUND_ON_CENTER:
			if randi() % TURN_CHANGE_RARITY == 0:
				constant_turn = smallRandomRange * turningStrength
			direction += constant_turn
	if direction > 2*PI: direction -= 2*PI
	global_position += movementSpeed * Vector2.from_angle(direction)

func handle_animation() -> void:
	glowSprite.modulate.h += COLOR_CHANGE_MULTIPLIER

func collected_by_player(player: Player) -> void:
	if !is_queued_for_deletion():
		player.collect_powerup(self)
	#...?
	queue_free()

func _physics_process(delta: float) -> void:
	handle_movement()
	handle_animation()
	if movementMode == FOLLOW_PLAYER && global_position.length() < CENTER_DISTANCE_LIMIT:
		movementMode = MOVE_AROUND_ON_CENTER
	for body in get_overlapping_bodies():
		if body is Player:
			collected_by_player(body)
	if framesOffScreen >= 0:
		framesOffScreen += 1
		if framesOffScreen >= OFF_SCREEN_FRAME_LIMIT:
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	framesOffScreen = -1

func _exit_tree() -> void:
	Global.POWERUPCOUNT -= 1
