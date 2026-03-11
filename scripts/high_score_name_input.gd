extends TextureRect
class_name HighScoreNameInput

const MENU_SHOW_TRANSITION_WEIGHT: float = 0.5

@export var input: LineEdit

signal closed

func _ready() -> void:
	visible = false

func _physics_process(delta):
	if visible:
		scale = scale.lerp(Vector2.ONE, MENU_SHOW_TRANSITION_WEIGHT)
	else:
		scale = Vector2.ZERO



func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_identifier():
		Global.HIGH_SCORE_HOLDER_NAME = new_text.to_upper()
		visible = false
		closed.emit()
