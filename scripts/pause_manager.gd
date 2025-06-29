extends Node
var isPaused: bool = false
@export var pauseMenuAnimationPlayer: AnimationPlayer
var musicBusIdx: int = AudioServer.get_bus_index("music")
const MUSIC_LPF_INDEX: int = 0
func _ready() -> void:
	pass # Replace with function body.

func pause_game() -> void:
	get_tree().paused = true
	isPaused = true
	pauseMenuAnimationPlayer.play("showPauseMenu")
	AudioServer.set_bus_effect_enabled(musicBusIdx, MUSIC_LPF_INDEX, true)

func unpause_game() -> void:
	get_tree().paused = false
	isPaused = false
	pauseMenuAnimationPlayer.play("hidePauseMenu")
	AudioServer.set_bus_effect_enabled(musicBusIdx, MUSIC_LPF_INDEX, false)

func _process(delta: float) -> void:
	if Global.INGAME:
		if Input.is_action_just_pressed("pause") && !isPaused:
			pause_game()
		if Input.is_action_just_pressed("unpause") && isPaused:
			unpause_game()
		if Input.is_action_just_pressed("kill") && isPaused:
			unpause_game()
			Global.GAME_MANAGER.kill_player()

func _on_unpause_button_pressed() -> void:
	if isPaused:
		unpause_game()
