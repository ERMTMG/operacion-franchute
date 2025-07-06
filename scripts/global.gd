extends Node
var GLOBAL_TIMER: int = 0
var INGAME: bool
var GAMETIME: float = 0
var SCORE: int = 0
var HIGH_SCORE: int = 0
var ENEMYCOUNT: int = 0
const MAXENEMYCOUNT: int = 128
var POWERUPCOUNT: int = 0
const MAXPOWERUPCOUNT: int = 16
var PROJECTILECOUNT: int = 0
const MAXPROJECTILECOUNT: int = 256
var PLAYERHEALTH: int
var PLAYERMAXHEALTH: int
enum BuffTypes {
	AMMO_BUFF = 0,
	BLUE_LASER_BUFF = 1,
	MULTISHOT_BUFF = 2,
}
var BUFF_TIMES: Array[int] # WHY can't you initialize arrays with a variable size
@export var GAME_MANAGER: Game
signal set_game_manager

enum {
	NONE = 0,
	OPTIONS_MENU = 1,
	SKINS_MENU = 2,
	BEFORE_QUIT_POPUP = 3,
	OPTIONS_MENU_SAVE_CONFIRMATION_POPUP = 4
}
var CURRENT_MENU_SHOWING: int = 0

func _init() -> void:
	pass # initialize game here?

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	BUFF_TIMES.resize(BuffTypes.values().size())
	BUFF_TIMES.fill(0)

func create_vfx_from_node(effect: Node2D, position: Vector2, foreground: bool = false, necessary: bool = false) -> void:
	if Settings.VFX_ENABLED || necessary:
		if !foreground:
			effect.global_position = position
			add_sibling(effect)
		else:
			effect.position = position
			var foregroundLayer: CanvasLayer = GAME_MANAGER.get_foreground_layer()
			foregroundLayer.add_child(effect)

func create_vfx(effect: PackedScene, position: Vector2, foreground: bool = false, necessary: bool = false) -> void:
	if Settings.VFX_ENABLED || necessary:
		var fx: Node2D = effect.instantiate()
		if !foreground:
			fx.global_position = position
			add_sibling(fx)
		else:
			fx.position = position
			var foregroundLayer: CanvasLayer = GAME_MANAGER.get_foreground_layer()
			foregroundLayer.add_child(fx)

func check_high_score() -> bool:
	if SCORE > HIGH_SCORE: 
		HIGH_SCORE = SCORE
		return true
	else:
		return false

func set_buff_time(type: BuffTypes, frames: int) -> void:
	BUFF_TIMES[type] = frames

func get_buff_time(type: BuffTypes) -> int:
	return BUFF_TIMES[type]

func reset_buffs() -> void:
	for buff in BuffTypes.values():
		BUFF_TIMES[buff] = 0

func update(delta: float) -> void:
	if GAME_MANAGER != null:
		set_game_manager.emit()
	GLOBAL_TIMER += 1
	for buff in BuffTypes.values():
		if BUFF_TIMES[buff] > 0: BUFF_TIMES[buff] -= 1

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if !Global.INGAME:
			GAME_MANAGER.ask_save_confirmation_before_quitting()
		else:
			get_tree().quit()
