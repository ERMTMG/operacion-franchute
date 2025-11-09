extends Control
class_name TutorialPopupClass
signal fading_out
@export var INITIAL_POSITIION: Vector2 = Vector2.ZERO
const FADE_TIME := 0.25
@export var quitButton: Button

func _ready() -> void:
	position = INITIAL_POSITIION

func fade_in_to(newPosition: Vector2) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", newPosition, FADE_TIME)

func fade_out():
	fading_out.emit()
	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2.ZERO, FADE_TIME)
	tween.finished.connect(func():
		queue_free()
		Global.SHOW_TUTORIAL = false
	)

func _on_quit_button_pressed() -> void:
	fade_out()
