extends Button

const DEFAULT_POS: Vector2 = Vector2(1066, 10)
const HIDDEN_POS: Vector2 = Vector2(1066, -80)
const TRANSITION_WEIGHT: float = 0.15

var currentTargetPos: Vector2 = DEFAULT_POS

func _ready() -> void:
	show_on_menu()

func show_on_menu() -> void:
	currentTargetPos = DEFAULT_POS

func hide_from_menu() -> void:
	currentTargetPos = HIDDEN_POS

func _physics_process(delta: float) -> void:
	if position != currentTargetPos:
		position = position.lerp(currentTargetPos, TRANSITION_WEIGHT)


func _on_pressed() -> void:
	if Global.CURRENT_MENU_SHOWING == Global.NONE:
		hide_from_menu()

func _on_quit_button_pressed() -> void:
	show_on_menu()
