extends Control
class_name ScoreLabel

# Code originally from Austin Dudas, modified slightly for center aligning, outline and enabling/disabling of the effect

@export var font_color: Color = Color.BLACK
@export var effect_color: Color = Color.WHITE
@export var font: Font
@export var outline_color: Color = Color.BLACK
@export var outline_width: int = 5
@export var effect_scale_increase: float = 0.5
@export var font_size: int = 16
@export var score: int = 0:
	set = _update_score
@export var effect_enabled: bool = true

var digits: Dictionary[int, String] = {
	0: "0",
	1: '0',
	2: '0',
	3: '0'
}

var digit_effects: Dictionary[String, float] = {
	"0": 0.0,
	"1": 0.0,
	"2": 0.0,
	"3": 0.0
}

var tweens: Dictionary[int, Tween] = {}

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	position.x = get_viewport_rect().size.x / 2 + 25
	var current_x: float = 0.0
	for i in digits.size():
		var effect = digit_effects[str(i)]
		var scale = 1.0 + effect * effect_scale_increase
		var digit_size = font.get_string_size(digits[i], 0, -1, font_size) 
		var scaled_digit_size = digit_size * scale
		draw_set_transform(
			Vector2(current_x, font.get_ascent(font_size) * scale) - (scaled_digit_size / 2.0),
			0,
			Vector2(scale, scale)
		)
		draw_char_outline(
			font,
			Vector2(-digit_size.x * 0.5, 0) if digits[i] == "1" else Vector2.ZERO,
			digits[i],
			font_size,
			outline_width,
			outline_color
		)
		draw_char(
			font,
			Vector2(-digit_size.x * 0.5, 0) if digits[i] == "1" else Vector2.ZERO,
			digits[i],
			font_size,
			lerp(font_color, effect_color, effect)
		)
		
		current_x += digit_size.x + (0.25*digit_size.x if digits[i] == "1" else 0)
	position.x -= current_x/2

func _update_score(val: int):
	if val == 0 and score != 0:
		digits.clear()
		digit_effects.clear()
		tweens.clear()
	elif val == score: return
	score = val
	var string_val: String = "%04d" % score
	if(val == 0): assert(string_val == "0000")
	if string_val.length() > digits.size():
		for i in digits.size() - string_val.length():
			digits.erase(digits.size() - 1)
			digit_effects.erase(str(digits.size() - 1))
	for i in string_val.length():
		if not digits.has(i) or digits[i] != string_val[i]:
			digits[i] = string_val[i]
			if effect_enabled:
				digit_effects[str(i)] = 1.0
				_digit_effect_tween(i)
			else:
				digit_effects[str(i)] = 0.0

func _digit_effect_tween(digit: int):
	if tweens.has(digit):
		tweens[digit].kill()
	var tween: Tween = create_tween()
	tween.tween_property(self, "digit_effects:%d" % digit, 0.0, 0.25)
	tweens[digit] = tween

func _physics_process(delta: float) -> void:
	_update_score(Global.SCORE)
