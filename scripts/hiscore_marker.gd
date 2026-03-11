extends TextureRect
class_name HighScoreScreenClass

const DEFAULT_POS: Vector2 = Vector2(105, -67)
const HIDDEN_POS: Vector2 = Vector2(105, -196)
const TRANSITION_WEIGHT: float = 0.15

@onready var text: Label = $Label
var currentTargetPos: Vector2 = HIDDEN_POS

func _ready() -> void:
	hide_from_menu()

func show_on_menu() -> void:
	currentTargetPos = DEFAULT_POS

func hide_from_menu() -> void:
	currentTargetPos = HIDDEN_POS

func update_high_score() -> void:
	text.text = "RÉCORD: %d PUNTOS\nPOR %s" % [Global.HIGH_SCORE, Global.HIGH_SCORE_HOLDER_NAME]

func _physics_process(delta: float) -> void:
	if position != currentTargetPos:
		position = position.lerp(currentTargetPos, TRANSITION_WEIGHT)
