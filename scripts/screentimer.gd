extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var timestring: String
	if Global.GAMETIME < 60 || Settings.CHRONOMETER_UNITS_MIN_SEC == false:
		timestring = var_to_str(Global.GAMETIME) + " s"
	else:
		var seconds: float = Global.GAMETIME - 60*floor(Global.GAMETIME / 60)
		if seconds < 0.1: seconds = 0
		timestring = var_to_str(int(Global.GAMETIME / 60)) + " min  " + var_to_str(seconds) + " s"
	text = timestring
