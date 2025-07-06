extends TextureRect
var gameManager: Game = Global.GAME_MANAGER
@export var rainbowBarCheck: CheckBox
@export var rainbowBarCheckLock: TextureRect
@export var optionsMenuPages: Array[Control]
@export var animationPlayer: AnimationPlayer
@export var saveConfirmationPopup: TextureRect
var currentlyActivePage: int = 0
@onready var musicBusID = AudioServer.get_bus_index("music")
@onready var sfxBusID = AudioServer.get_bus_index("sfx")
const MENU_SHOW_TRANSITION_WEIGHT: float = 0.5
const MENU_SOUNDS: Dictionary[StringName, AudioStream] = {
	&"OPTIONS_GEAR": preload("res://sounds/menu/options_gear.mp3"),
	&"WINDOW_POPUP": preload("res://sounds/menu/window_popup.mp3"),
	&"WINDOW_CLOSE": preload("res://sounds/menu/window_close.wav"),
	&"CHECKBOX_TAP": preload("res://sounds/menu/checkbox_tap.mp3"),
	&"BUTTON_PRESS": preload("res://sounds/menu/button_press.wav"),
}

const POINTS_FOR_RAINBOW_BARS: int = 50000
@onready var CHECKBOXES: Array[CheckBox] = [
	$page1/MarginContainer/VBoxContainer/GridContainer2/Control/screenFlashCheck, 
	$page1/MarginContainer/VBoxContainer/GridContainer2/Control2/enemyFlashCheck, 
	$page1/MarginContainer/VBoxContainer/GridContainer2/Control3/screenShakeCheck, 
	$page1/MarginContainer/VBoxContainer/GridContainer2/Control4/vfxCheck, 
	$page2/MarginContainer/VBoxContainer/GridContainer2/Control/timerUnitCheck, 
	$page2/MarginContainer/VBoxContainer/GridContainer2/Control2/enemyBarsCheck, 
	$page2/MarginContainer/VBoxContainer/GridContainer2/Control3/rainbowBarCheck, 
	$page2/MarginContainer/VBoxContainer/GridContainer2/Control4/pauseScreenFilterCheck, 
	$page2/MarginContainer/VBoxContainer/GridContainer2/Control5/fancyScoreCheck
]
@onready var CHECKBOX_SETTINGS: Dictionary[CheckBox, StringName] = {
	CHECKBOXES[0]: &"SCREEN_FLASH_ENABLED",
	CHECKBOXES[1]: &"ENEMY_FLASH_ENABLED",
	CHECKBOXES[2]: &"SCREEN_SHAKE_ENABLED",
	CHECKBOXES[3]: &"VFX_ENABLED",
	CHECKBOXES[4]: &"CHRONOMETER_UNITS_MIN_SEC",
	CHECKBOXES[5]: &"ENEMY_HP_BARS_ENABLED",
	CHECKBOXES[6]: &"RAINBOW_HP_BARS_ENABLED",
	CHECKBOXES[7]: &"PAUSE_SCREEN_FILTER_ENABLED",
	CHECKBOXES[8]: &"FANCY_SCORE_COUNTER_ENABLED"
}
@onready var SLIDERS: Array[HSlider] = [
	$page1/MarginContainer/VBoxContainer/GridContainer/musicslider, 
	$page1/MarginContainer/VBoxContainer/GridContainer/sfxslider
]
@onready var SLIDER_SETTINGS: Dictionary[HSlider, StringName] = {
	SLIDERS[0]: &"MUSIC_VOLUME",
	SLIDERS[1]: &"SFX_VOLUME"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("RESET")
	visible = false
	for page in optionsMenuPages:
		page.visible = false
	optionsMenuPages[currentlyActivePage].visible = true

func _physics_process(delta):
	if gameManager == null: gameManager = Global.GAME_MANAGER 
	if visible:
		scale = scale.lerp(Vector2.ONE, MENU_SHOW_TRANSITION_WEIGHT)
	else:
		scale = Vector2.ZERO
	var rainbowBarsLocked: bool = (Global.HIGH_SCORE < POINTS_FOR_RAINBOW_BARS)
	rainbowBarCheck.disabled = rainbowBarsLocked
	rainbowBarCheckLock.visible = rainbowBarsLocked
	


func _on_optionsbutton_pressed():
	if Global.CURRENT_MENU_SHOWING == Global.NONE:
		gameManager.play_sfx(MENU_SOUNDS["WINDOW_POPUP"])
		visible = true
		Global.CURRENT_MENU_SHOWING = Global.OPTIONS_MENU

func _on_quit_button_pressed():
	visible = false
	Global.CURRENT_MENU_SHOWING = Global.NONE
	gameManager.play_sfx(MENU_SOUNDS["WINDOW_CLOSE"])

func _on_musicslider_value_changed(value):
	Settings.MUSIC_VOLUME = value
	AudioServer.set_bus_volume_db(musicBusID, linear_to_db(value))

func _on_sfxslider_value_changed(value):
	Settings.SFX_VOLUME = value
	AudioServer.set_bus_volume_db(sfxBusID, linear_to_db(value))

func _on_screen_flash_check_toggled(toggled_on: bool) -> void:
	Settings.SCREEN_FLASH_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("screenFlashButtonPress")

func _on_screen_shake_check_toggled(toggled_on: bool) -> void:
	Settings.SCREEN_SHAKE_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("screenShakeButtonPress")

func _on_vfx_check_toggled(toggled_on: bool) -> void:
	Settings.VFX_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("vfxButtonPress")

func _on_enemy_flash_check_toggled(toggled_on: bool) -> void:
	Settings.ENEMY_FLASH_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("enemyFlashButtonPress")

func _on_timer_unit_check_toggled(toggled_on: bool) -> void:
	Settings.CHRONOMETER_UNITS_MIN_SEC = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("timerUnitButtonPress")

func _on_enemy_bars_check_toggled(toggled_on: bool) -> void:
	Settings.ENEMY_HP_BARS_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("enemyBarsButtonPress")

func _on_rainbow_bar_check_toggled(toggled_on: bool) -> void:
	Settings.RAINBOW_HP_BARS_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("rainbowBarButtonPress")

func _on_pause_screen_filter_check_toggled(toggled_on: bool) -> void:
	Settings.PAUSE_SCREEN_FILTER_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("pauseScreenFilterButtonPress")

func _on_fancy_score_check_toggled(toggled_on: bool) -> void:
	Settings.FANCY_SCORE_COUNTER_ENABLED = toggled_on
	gameManager.play_sfx(MENU_SOUNDS["CHECKBOX_TAP"])
	animationPlayer.play("RESET")
	animationPlayer.play("fancyScoreButtonPress")

func _on_button_switch_page_right_pressed() -> void:
	optionsMenuPages[currentlyActivePage].visible = false
	currentlyActivePage = (currentlyActivePage + 1) % optionsMenuPages.size()
	optionsMenuPages[currentlyActivePage].visible = true
	gameManager.play_sfx(MENU_SOUNDS["BUTTON_PRESS"])
	animationPlayer.play("RESET")
	animationPlayer.play("switchPageRight")

func _on_button_switch_page_left_pressed() -> void:
	optionsMenuPages[currentlyActivePage].visible = false
	currentlyActivePage = (currentlyActivePage - 1) % optionsMenuPages.size()
	optionsMenuPages[currentlyActivePage].visible = true
	gameManager.play_sfx(MENU_SOUNDS["BUTTON_PRESS"])
	animationPlayer.play("RESET")
	animationPlayer.play("switchPageLeft")

func _on_visibility_changed() -> void:
	if visible:
		for checkbox in CHECKBOXES:
			checkbox.button_pressed = Settings.get(CHECKBOX_SETTINGS[checkbox])
		for slider in SLIDERS:
			slider.value = Settings.get(SLIDER_SETTINGS[slider])

func _on_save_button_pressed() -> void:
	if Global.CURRENT_MENU_SHOWING == Global.OPTIONS_MENU:
		gameManager.play_sfx(MENU_SOUNDS["BUTTON_PRESS"])
		animationPlayer.play("saveButtonPress")
		Global.CURRENT_MENU_SHOWING = Global.OPTIONS_MENU_SAVE_CONFIRMATION_POPUP
		saveConfirmationPopup.show()
