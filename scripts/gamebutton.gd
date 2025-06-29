extends Button
class_name GameStartButton
@onready var closed_texture = preload("res://sprites/button.svg")
@onready var open_texture = preload("res://sprites/button_open.svg")
@onready var pressed_texture = preload("res://sprites/button_pressed.svg")
@onready var pressSound: AudioStream = preload("res://sounds/start_button_pressed.mp3")
var movingDown: bool = false
var movingUp: bool = false
var hasBeenPressed: bool = false
var time = 0
const YPOS = 397
signal buttonDown

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	modulate.r = move_toward(modulate.r,1.0,0.05)
	modulate.g = move_toward(modulate.g,1.0,0.05)
	modulate.b = move_toward(modulate.b,1.0,0.05)
	if movingDown:
		position.y += time
		time += 1
		if position.y > 700: movingDown = false
	if movingUp:
		icon = closed_texture
		position.y = move_toward(position.y, YPOS, 5)
		if position.y == YPOS:
			movingUp = false
			hasBeenPressed = false
	if !hasBeenPressed:
		if is_hovered():
			icon = open_texture
			position.y = YPOS - 3
		else:
			icon = closed_texture
			position.y = YPOS

func _on_pressed():
	if($Timer.is_stopped()):
		hasBeenPressed = true
		icon = pressed_texture
		position.y = YPOS - 3
		$Timer.start()
		modulate = Color(2.0,2.0,2.0)
		Global.GAME_MANAGER.play_sfx(pressSound, 2.0)

func moveup():
	movingUp = true

func _on_timer_timeout():
	movingDown = true
	buttonDown.emit()
