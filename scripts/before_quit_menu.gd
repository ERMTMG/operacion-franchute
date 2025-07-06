extends TextureRect

const MENU_SHOW_TRANSITION_WEIGHT: float = 0.5
const BEFORE_QUIT_MENU_SOUNDS: Dictionary[StringName, AudioStream] = {
	&"WINDOW_POPUP": preload("res://sounds/menu/window_popup.mp3"),
	&"WINDOW_CLOSE": preload("res://sounds/menu/window_close.wav"),
	&"BUTTON_PRESS": preload("res://sounds/menu/button_press.wav"),
}
@export var animationPlayer: AnimationPlayer
var menuToComeBackTo: int

func play_window_close_sound() -> void:
	Global.GAME_MANAGER.play_sfx(BEFORE_QUIT_MENU_SOUNDS[&"WINDOW_CLOSE"])

func _ready() -> void:
	visible = false

func _physics_process(delta):
	if visible:
		scale = scale.lerp(Vector2.ONE, MENU_SHOW_TRANSITION_WEIGHT)
	else:
		scale = Vector2.ZERO

func _on_save_button_pressed() -> void:
	Global.GAME_MANAGER.play_sfx(BEFORE_QUIT_MENU_SOUNDS[&"BUTTON_PRESS"])
	animationPlayer.play("saveButtonPress")
	SaveManager.serialize_and_save_game()
	await animationPlayer.animation_finished
	get_tree().quit()

func _on_dont_save_button_pressed() -> void:
	Global.GAME_MANAGER.play_sfx(BEFORE_QUIT_MENU_SOUNDS[&"BUTTON_PRESS"])
	animationPlayer.play("dontSaveButtonPress")
	await animationPlayer.animation_finished
	get_tree().quit()

func _on_dont_quit_button_pressed() -> void:
	Global.GAME_MANAGER.play_sfx(BEFORE_QUIT_MENU_SOUNDS[&"BUTTON_PRESS"])
	animationPlayer.play("dontQuitButtonPress")
	await animationPlayer.animation_finished
	visible = false
	Global.CURRENT_MENU_SHOWING = menuToComeBackTo

func _on_visibility_changed() -> void:
	if visible and Global.GAME_MANAGER != null:
		Global.GAME_MANAGER.play_sfx(BEFORE_QUIT_MENU_SOUNDS[&"WINDOW_POPUP"])
