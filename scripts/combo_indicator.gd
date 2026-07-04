extends Control
class_name ComboIndicator

@export var animationPlayer: AnimationPlayer
@export var numberSprite: Sprite2D
@export var comboManager: ComboManager

const COMBO_NUMBER_SPRITES: Dictionary[int, Texture2D] = {
	2: preload("res://sprites/combo_indicator/2.svg"),
	3: preload("res://sprites/combo_indicator/3.svg"),
	4: preload("res://sprites/combo_indicator/4.svg"),
	5: preload("res://sprites/combo_indicator/5.svg"),
	6: preload("res://sprites/combo_indicator/6.svg"),
	7: preload("res://sprites/combo_indicator/7.svg"),
	8: preload("res://sprites/combo_indicator/8.svg"),
}
const MIN_COMBO_NUMBER := 2
const MAX_COMBO_NUMBER := 8

static func _static_init() -> void:
	COMBO_NUMBER_SPRITES.make_read_only()

var _current_combo_number: int

func set_number_sprite():
	if _current_combo_number >= MAX_COMBO_NUMBER:
		numberSprite.texture = COMBO_NUMBER_SPRITES[MAX_COMBO_NUMBER]
	elif _current_combo_number >= MIN_COMBO_NUMBER:
		numberSprite.texture = COMBO_NUMBER_SPRITES[_current_combo_number]

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
