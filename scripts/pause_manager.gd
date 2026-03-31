extends Node
class_name PauseManager
var isPaused: bool = false
@export var pauseMenuAnimationPlayer: AnimationPlayer
var musicBusIdx: int = AudioServer.get_bus_index("music")
const MUSIC_LPF_INDEX: int = 0
const PAUSE_EXIT_DELAY: float = 0.1
signal paused
signal unpaused
func _ready() -> void:
	pass # Replace with function body.

func pause_game() -> void:
	isPaused = true
	get_tree().paused = true
	paused.emit()
	pauseMenuAnimationPlayer.play("showPauseMenu")
	AudioServer.set_bus_effect_enabled(musicBusIdx, MUSIC_LPF_INDEX, true)

func unpause_game() -> void:
	get_tree().paused = false
	isPaused = false
	unpaused.emit()
	pauseMenuAnimationPlayer.play("hidePauseMenu")
	AudioServer.set_bus_effect_enabled(musicBusIdx, MUSIC_LPF_INDEX, false)
	await pauseMenuAnimationPlayer.animation_finished
	

func _process(delta: float) -> void:
	if Global.INGAME:
		if Input.is_action_just_pressed("pause") && !isPaused:
			pause_game()
		elif Input.is_action_just_pressed("unpause") && isPaused:
			unpause_game()

func _on_resume_button_pressed() -> void:
	pauseMenuAnimationPlayer.play(&"unpauseButtonPress")
	await get_tree().create_timer(PAUSE_EXIT_DELAY).timeout
	if isPaused:
		unpause_game()

func _on_kill_button_pressed() -> void:
	pauseMenuAnimationPlayer.play(&"killButtonPress")
	await get_tree().create_timer(PAUSE_EXIT_DELAY).timeout
	if isPaused:
		unpause_game()
		Global.GAME_MANAGER.kill_player()
