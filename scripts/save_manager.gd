@icon("res://sprites/croissant.svg")
extends Node
class_name SaveManager

const SETTINGS_NAMES: Array[StringName] = [
	&"MUSIC_VOLUME",
	&"SFX_VOLUME",
	&"SCREEN_FLASH_ENABLED",
	&"SCREEN_SHAKE_ENABLED",
	&"VFX_ENABLED",
	&"ENEMY_FLASH_ENABLED",
	&"CHRONOMETER_UNITS_MIN_SEC",
	&"ENEMY_HP_BARS_ENABLED",
	&"RAINBOW_HP_BARS_ENABLED",
	&"PAUSE_SCREEN_FILTER_ENABLED",
	&"FANCY_SCORE_COUNTER_ENABLED",
]

const RECORDS_NAMES: Array[StringName] = [
	&"HIGH_SCORE"
]

static func serialize_and_save_game() -> void:
	SaveSystem.set_clear_data(true)
	serialize_game_data()
	SaveSystem.save()

static func serialize_game_data() -> void:
	var gameSave: GameSaveResource = GameSaveResource.new()
	_serialize_settings(gameSave)
	_serialize_records(gameSave)
	SaveSystem.set_var("save_data", gameSave)

static func _serialize_settings(gameSave: GameSaveResource) -> void:
	for setting in SETTINGS_NAMES:
		var settingValue = Settings.get(setting)
		gameSave.set(setting, settingValue)

static func _serialize_records(gameSave: GameSaveResource) -> void:
	for record in RECORDS_NAMES:
		var recordValue = Global.get(record)
		gameSave.set(record, recordValue)

static func load_game_data() -> void:
	if SaveSystem.has("save_data"):
		print(SaveSystem.get_var("save_data"))
		var gameSave: Dictionary = SaveSystem.get_var("save_data")
		_load_settings(gameSave)
		_load_records(gameSave)
	else:
		print("Save data not found. Loading game with default data...")
	

static func _load_settings(gameSave: Dictionary) -> void:
	for setting in SETTINGS_NAMES:
		if setting in gameSave:
			var settingValue = gameSave[setting]
			Settings.set(setting, settingValue)
		else:
			push_warning("Setting " + setting + " not found in save data. Might be corrupted")

static func _load_records(gameSave: Dictionary) -> void:
	for record in RECORDS_NAMES:
		if record in gameSave:
			var recordValue = gameSave[record]
			print(record, " is ", recordValue)
			Global.set(record, recordValue)
