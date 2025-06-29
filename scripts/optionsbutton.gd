extends Button
var spriteAngVel = 0
const OPTIONS_GEAR_SOUND: AudioStream = preload("res://sounds/menu/options_gear.mp3")
func _ready():
	pass

func _physics_process(delta):
	$Sprite2D.rotation_degrees += spriteAngVel
	spriteAngVel *= 0.9
	if $Sprite2D.scale.x != 0.35:
		$Sprite2D.scale += 0.2*(0.35-$Sprite2D.scale.x)*Vector2.ONE 

func _on_pressed():
	if Global.CURRENT_MENU_SHOWING == Global.NONE:
		disabled = true
		Global.GAME_MANAGER.play_sfx(OPTIONS_GEAR_SOUND)
		spriteAngVel += 10
		$Sprite2D.scale += 0.2*Vector2.ONE

func _on_quit_button_pressed():
	disabled = false
