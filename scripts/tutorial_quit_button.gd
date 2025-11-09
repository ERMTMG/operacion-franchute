extends Button
@export var sprite: Sprite2D

const NORMAL_SCALE := 1.0 * Vector2.ONE
const HOVERED_SCALE := 1.075 * Vector2.ONE
const PRESSED_SCALE := 1.2 * Vector2.ONE
const HOVER_TWEEN_DURATION := 0.1
const PRESS_TWEEN_DURATION := 0.25
var was_hovered = false

func _physics_process(delta: float) -> void:
	var hovered = is_hovered()
	if hovered && !was_hovered:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(sprite, "scale", HOVERED_SCALE, HOVER_TWEEN_DURATION)
	elif !hovered && was_hovered:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(sprite, "scale", NORMAL_SCALE, HOVER_TWEEN_DURATION)
	was_hovered = hovered

func _on_pressed() -> void:
	sprite.scale = PRESSED_SCALE
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)\
		 .set_trans(Tween.TRANS_BACK)\
		 .tween_property(sprite, "scale", NORMAL_SCALE, PRESS_TWEEN_DURATION)
	Global.GAME_MANAGER.play_sfx(load("res://sounds/menu/button_press.wav") as AudioStream)
