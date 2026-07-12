extends Control
class_name ComboIndicator

@export var animationPlayer: AnimationPlayer
@export var numberSprite: AnimatedSprite2D
@export var comboManager: ComboManager

@export var COMBO_SOUNDS: Array[AudioStream]
@export var COMBO_FINISH_WOOSH_SOUND: AudioStream
const MIN_COMBO_NUMBER := 2
const MAX_COMBO_NUMBER := 8

var currentComboNumber: int

func set_number_sprite():
	if currentComboNumber >= MAX_COMBO_NUMBER:
		numberSprite.frame = MAX_COMBO_NUMBER
	elif currentComboNumber >= MIN_COMBO_NUMBER:
		numberSprite.frame = currentComboNumber

func _on_combo_changed(newValue: int):
	currentComboNumber = newValue + 1
	var soundToPlay: AudioStream
	if newValue == 1:
		soundToPlay = COMBO_SOUNDS[0]
		Global.GAME_MANAGER.play_sfx(soundToPlay, false, 1.2)
		set_number_sprite()
		visible = true
		animationPlayer.play(&"appear")
		await animationPlayer.animation_finished
		animationPlayer.play(&"RESET")
	elif newValue == 0:
		animationPlayer.play(&"disappear")
		soundToPlay = COMBO_FINISH_WOOSH_SOUND
		Global.GAME_MANAGER.play_sfx(soundToPlay, false, 1.7)
		await animationPlayer.animation_finished
		visible = false
	else:
		if currentComboNumber > MAX_COMBO_NUMBER:
			soundToPlay = COMBO_SOUNDS[MAX_COMBO_NUMBER - 2]
		else:
			soundToPlay = COMBO_SOUNDS[currentComboNumber - 2]
		Global.GAME_MANAGER.play_sfx(soundToPlay, false, 1.2)
		animationPlayer.play(&"increment")

func _process(delta: float) -> void:
	var shader_progress := 1.0 - comboManager.get_current_combo_time_left() / comboManager.get_current_combo_time_window()
	var material = numberSprite.material as ShaderMaterial
	material.set_shader_parameter(&"progress", shader_progress)
