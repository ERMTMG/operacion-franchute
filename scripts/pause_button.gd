extends Button
class_name PauseButtonClass

@export var sprite: Sprite2D
var last_frame_hovered: bool

const DEFAULT_POS: Vector2 = Vector2(0, 53)
const HIDDEN_POS: Vector2 = Vector2(-100, 53)
const TWEEN_DURATION: float = 0.25
const CLICK_TWEEN_DURATION: float = 0.35
const SIZE_CLICKED: Vector2 = 0.5 * Vector2.ONE
const SIZE_HOVERED: Vector2 = 0.43 * Vector2.ONE
const SIZE_DEFAULT: Vector2 = 0.4 * Vector2.ONE

func hide_from_screen() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)\
		 .set_trans(Tween.TRANS_QUAD)\
		 .tween_property(self, "position", HIDDEN_POS, TWEEN_DURATION)

func show_on_screen() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)\
		 .set_trans(Tween.TRANS_QUAD)\
		 .tween_property(self, "position", DEFAULT_POS, TWEEN_DURATION)

func _ready() -> void:
	last_frame_hovered = false;

func click_button_animation() -> void:
	sprite.scale = SIZE_CLICKED
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)\
		 .set_ease(Tween.EASE_OUT)\
		 .tween_property(sprite, "scale", SIZE_DEFAULT, CLICK_TWEEN_DURATION)

func _physics_process(delta: float) -> void:
	if is_hovered() && !last_frame_hovered:
		var tween: Tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)\
			 .tween_property(sprite, "scale", SIZE_HOVERED, CLICK_TWEEN_DURATION)
	elif !is_hovered() && last_frame_hovered:
		var tween: Tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)\
			 .tween_property(sprite, "scale", SIZE_DEFAULT, CLICK_TWEEN_DURATION)
	last_frame_hovered = is_hovered()


func _on_pressed() -> void:
	click_button_animation()
	hide_from_screen()
