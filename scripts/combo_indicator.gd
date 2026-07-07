extends Control
class_name ComboIndicator

@export var animationPlayer: AnimationPlayer
@export var numberSprite: AnimatedSprite2D
@export var comboManager: ComboManager

@export var COMBO_NUMBER_SPRITES: AnimatedTexture 
const MIN_COMBO_NUMBER := 2
const MAX_COMBO_NUMBER := 8

var _current_combo_number: int

func set_number_sprite():
	if _current_combo_number >= MAX_COMBO_NUMBER:
		numberSprite.frame = MAX_COMBO_NUMBER
	elif _current_combo_number >= MIN_COMBO_NUMBER:
		numberSprite.frame = _current_combo_number

func _on_combo_changed(newValue: int):
	_current_combo_number = newValue + 1
	if newValue == 1:
		print("new combo!")
		set_number_sprite()
		visible = true
		animationPlayer.play(&"appear")
		await animationPlayer.animation_finished
		animationPlayer.play(&"RESET")
	elif newValue == 0:
		animationPlayer.play(&"disappear")
		await animationPlayer.animation_finished
		visible = false
	else:
		animationPlayer.play(&"increment")

func _process(delta: float) -> void:
	var shader_progress := 1.0 - comboManager.get_current_combo_time_left() / comboManager.get_current_combo_time_window()
	var material = numberSprite.material as ShaderMaterial
	material.set_shader_parameter(&"progress", shader_progress)
