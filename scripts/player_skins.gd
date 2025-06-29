extends Node

const PLAYER_SKIN_HUE_INCREMENT: float = 0.05

enum {
	SKIN_PROPERTY_SPARKLE = 1,
	SKIN_PROPERTY_RAINBOW = 2,
	SKIN_PROPERTY_OTHER = 4,
	SKIN_PROPERTY_OTHER2 = 8,
	# ...
}

class PlayerSkinInfo:
	var texture: Texture2D
	var skinName: String
	var pointsNecessary: int
	var supportsColor: bool
	var skinPropertyFlags: int
	
	func _init(textureFilename: String, name: String, points: int, color: bool, flags: int = 0) -> void:
		texture = load(textureFilename)
		skinName = name
		pointsNecessary = points
		supportsColor = color
		skinPropertyFlags = flags

func _player_skin(textureFilename: String, name: String, points: int, color: bool, flags: int = 0) -> PlayerSkinInfo:
	return PlayerSkinInfo.new(textureFilename, name, points, color, flags)

var PLAYER_SKINS: Array[PlayerSkinInfo] = [ # i wish i could make this a const
	_player_skin("res://sprites/player_skins/skin1.svg", "VIVA ESPAÑA", 0, false),
	_player_skin("res://sprites/player_skins/skin2.svg", "NAVE BRITÁNICA ELIZABETH III", 0, false),
	_player_skin("res://sprites/player_skins/skin3.svg", "TRAIDOR", 0, false),
	_player_skin("res://sprites/player_skins/skin4.svg", "PARTIDO NEUTRAL", 0, false),
	_player_skin("res://sprites/player_skins/skin5.svg", "LA VERDADERA BANDERA FRANCESA", 0, false),
	_player_skin("res://sprites/player_skins/skin6.svg", "MONOCROMÁTICO", 0, true),
	_player_skin("res://sprites/player_skins/skin7.svg", "MITAD Y MITAD", 0, true),
	_player_skin("res://sprites/player_skins/skin8.svg", "DEGRADADO", 0, true),
	_player_skin("res://sprites/player_skins/skin9.svg", "PASTELITO", 0, true),
	_player_skin("res://sprites/player_skins/skin10.svg", "ESTAFA PIRAMIDAL", 5000, false),
	_player_skin("res://sprites/player_skins/skin11.svg", "ECOLOGISTA", 5000, false),
	_player_skin("res://sprites/player_skins/skin12.svg", "¿¡A QUE TE PINXO?!", 10000, false),
	_player_skin("res://sprites/player_skins/skin13.svg", "FONTANERO LEGALMENTE DISTINTO", 10000, false),
	_player_skin("res://sprites/player_skins/skin14.svg", "ORGULLOSO (DE NO SER FRANCÉS)", 20000, false),
	_player_skin("res://sprites/player_skins/skin15.svg", "GUA GUA", 25000, false),
	_player_skin("res://sprites/player_skins/skin16.svg", "MIAU MIAU", 25000, false),
	_player_skin("res://sprites/player_skins/skin17.svg", "PIO PIO", 25000, false),
	_player_skin("res://sprites/player_skins/skin18.svg", "HEAVY METAL", 30000, true, SKIN_PROPERTY_SPARKLE),
	_player_skin("res://sprites/player_skins/skin19.svg", "HEAVY SILVER", 30000, false, SKIN_PROPERTY_SPARKLE),
	_player_skin("res://sprites/player_skins/skin20.svg", "SENDA ARCOÍRIS", 50000, false, SKIN_PROPERTY_RAINBOW),
]

@export var CURRENT_SKIN_SHOWING: int = 0
@export var CURRENT_PLAYER_SKIN: int = 0
@export var TARGET_SKIN_HUE_SHIFT: float = 0
@export var ACTUAL_SKIN_HUE_SHIFT: float = 0

func get_skin_texture(playerSkinIdx: int) -> Texture2D:
	return PLAYER_SKINS[playerSkinIdx].texture

func get_skin_name(playerSkinIdx: int) -> String:
	return PLAYER_SKINS[playerSkinIdx].skinName

func supports_color(playerSkinIdx: int) -> bool:
	return PLAYER_SKINS[playerSkinIdx].supportsColor

func is_skin_rainbow(playerSkinIdx: int) -> bool:
	return PLAYER_SKINS[playerSkinIdx].skinPropertyFlags & SKIN_PROPERTY_RAINBOW > 0

func is_skin_sparkle(playerSkinIdx: int) -> bool:
	return PLAYER_SKINS[playerSkinIdx].skinPropertyFlags & SKIN_PROPERTY_SPARKLE > 0


func is_skin_menu_active() -> bool:
	return (Global.CURRENT_MENU_SHOWING == Global.SKINS_MENU)
	
func get_relevant_skin_idx() -> int:
	if is_skin_menu_active(): return CURRENT_SKIN_SHOWING
	else: return CURRENT_PLAYER_SKIN

func set_skin() -> void:
	CURRENT_PLAYER_SKIN = CURRENT_SKIN_SHOWING

#func next_skin() -> void:
#	CURRENT_PLAYER_SKIN = (CURRENT_PLAYER_SKIN + 1) % PLAYER_SKINS.size()
#	if !current_player_skin_supports_color(): SKIN_HUE_SHIFT = 0
#func prev_skin() -> void:
#	CURRENT_PLAYER_SKIN = (CURRENT_PLAYER_SKIN - 1) % PLAYER_SKINS.size()
#	if !current_player_skin_supports_color(): SKIN_HUE_SHIFT = 0

func manage_skin_color(playerSkinIdx: int) -> void:
	if PLAYER_SKINS[playerSkinIdx].supportsColor:
		ACTUAL_SKIN_HUE_SHIFT = TARGET_SKIN_HUE_SHIFT
	else:
		ACTUAL_SKIN_HUE_SHIFT = 0

func is_skin_currently_selectable(playerSkinIdx: int) -> bool:
	return PLAYER_SKINS[playerSkinIdx].pointsNecessary <= Global.HIGH_SCORE
	
func show_next_skin() -> void:
	CURRENT_SKIN_SHOWING = (CURRENT_SKIN_SHOWING + 1) % PLAYER_SKINS.size()
	manage_skin_color(CURRENT_SKIN_SHOWING)

func show_prev_skin() -> void:
	CURRENT_SKIN_SHOWING = (CURRENT_SKIN_SHOWING - 1) % PLAYER_SKINS.size()
	manage_skin_color(CURRENT_SKIN_SHOWING)


func increase_skin_hue_shift() -> void:
	TARGET_SKIN_HUE_SHIFT += PLAYER_SKIN_HUE_INCREMENT
	if TARGET_SKIN_HUE_SHIFT > 1: TARGET_SKIN_HUE_SHIFT -= 1
	manage_skin_color(get_relevant_skin_idx())
	

func decrease_skin_hue_shift() -> void:
	TARGET_SKIN_HUE_SHIFT -= PLAYER_SKIN_HUE_INCREMENT
	if TARGET_SKIN_HUE_SHIFT < 0: TARGET_SKIN_HUE_SHIFT += 1
	manage_skin_color(get_relevant_skin_idx())

func is_shown_skin_currently_selectable() -> bool:
	return PLAYER_SKINS[CURRENT_SKIN_SHOWING].pointsNecessary <= Global.HIGH_SCORE

func get_skin_points_needed(playerSkinIdx: int) -> int:
	return PLAYER_SKINS[playerSkinIdx].pointsNecessary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
