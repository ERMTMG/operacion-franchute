extends TextureRect
class_name HighScoreNameInput

const MENU_SHOW_TRANSITION_WEIGHT: float = 0.5

@export var input: LineEdit
@export var animationPlayer: AnimationPlayer
@onready var denySound: AudioStream = load("res://sounds/menu/button_deny.mp3")

var ALLOWED_REGEX := RegEx.create_from_string(
	"[A-Z0-9_\\- \\|@\\(\\)]+"
)

signal closed

func _ready() -> void:
	visible = false

func open() -> void:
	self.visible = true
	Global.CURRENT_MENU_SHOWING = Global.HISH_SCORE_BEAT_POPUP

func close() -> void:
	self.visible = false
	Global.CURRENT_MENU_SHOWING = Global.NONE

func _physics_process(delta):
	if visible:
		scale = scale.lerp(Vector2.ONE, MENU_SHOW_TRANSITION_WEIGHT)
	else:
		scale = Vector2.ZERO

func name_valid(name: String) -> bool:
	name = name.to_upper() \
			   .replace('Á', 'A') \
			   .replace('É', 'E') \
			   .replace('Í', 'I') \
			   .replace('Ó', 'O') \
			   .replace('Ú', 'U') \
			   .replace('Ü', 'U') \
			   .replace('Ñ', 'N')
	var regex_match: RegExMatch = ALLOWED_REGEX.search(name)
	if regex_match == null || regex_match.get_string() != name:
		return false
	const SWEARS: PackedStringArray = [
		# English
		"FUCK",
		"SHIT", 
		"BITCH",
		"ASSHOLE",
		"BASTARD",
		"DICK",
		"PUSSY",
		"CUNT",
		"COCK",
		"SLUT",
		"WHORE",
		"DAMN",
		"NIGGA",
		"NIGGER",
		
		# Spanish
		"PUTA", "PUTO",
		"MIERDA",
		"COÑO",
		"POLLA",
		"JODER",
		"JODIDO", "JODIDA",
		"VERGA",
		"PENDEJO", "PENDEJA",
		"CABRON",
		"MARICON",
	] # Quiero suponer que esta lista será bastante para la lan party?
	for swear in SWEARS:
		if name.contains(swear):
			return false
	return true

func _on_line_edit_text_submitted(new_text: String) -> void:
	if name_valid(new_text):
		Global.HIGH_SCORE_HOLDER_NAME = new_text.to_upper()
		close()
		closed.emit()
	else:
		Global.GAME_MANAGER.play_sfx(denySound)
		animationPlayer.play(&"nameDenied")

func _on_line_edit_text_changed(new_text: String) -> void:
	var old_caret_pos := input.caret_column
	input.text = new_text.to_upper()
	input.caret_column = old_caret_pos
