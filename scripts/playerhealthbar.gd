extends Control

@onready var fill = $fill
@onready var barend = $end
@onready var text = $Label
const FULLHEALTHWIDTH = 352
var barcolor: Color
var playerhealthfloat: float

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	playerhealthfloat = (1.0*Global.PLAYERHEALTH / Global.PLAYERMAXHEALTH)
	if is_finite(playerhealthfloat): fill.size.x = FULLHEALTHWIDTH*playerhealthfloat # else something has gone wrong and idk what it is
	if playerhealthfloat > 0.7: barcolor = Color.GREEN
	else:
		barcolor = Color.from_hsv(0.428*playerhealthfloat,1,1)
	fill.modulate = barcolor
	barend.modulate = barcolor
	barend.position = Vector2(fill.position.x + fill.size.x, fill.position.y)
	text.text = str(Global.PLAYERHEALTH, " / ", Global.PLAYERMAXHEALTH)
	if playerhealthfloat == 0:
		barend.visible = false
	else:
		barend.visible = true
