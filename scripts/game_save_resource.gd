extends Resource
class_name GameSaveResource

# SETTINGS
@export var MUSIC_VOLUME: float = 1.0
@export var SFX_VOLUME: float = 1.0
@export var SCREEN_FLASH_ENABLED: bool = true
@export var SCREEN_SHAKE_ENABLED: bool = true
@export var VFX_ENABLED: bool = true
@export var ENEMY_FLASH_ENABLED: bool = true
@export var CHRONOMETER_UNITS_MIN_SEC: bool = true
@export var ENEMY_HP_BARS_ENABLED: bool = true
@export var RAINBOW_HP_BARS_ENABLED: bool = false
@export var PAUSE_SCREEN_FILTER_ENABLED: bool = true
@export var FANCY_SCORE_COUNTER_ENABLED: bool = true

# GLOBALS (that should be kept across games)
var HIGH_SCORE: int = 0

# PLAYER SKIN INFO
@export var CURRENT_SKIN_SHOWING: int = 0
@export var CURRENT_PLAYER_SKIN: int = 0
@export var TARGET_SKIN_HUE_SHIFT: float = 0
@export var ACTUAL_SKIN_HUE_SHIFT: float = 0
