extends Camera2D
@onready var bottom = $boundary/bottom
@onready var top = $boundary/top
@onready var left = $boundary/left
@onready var right = $boundary/right
var time = 0
var mult = 0.1
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	time += 0.02
	if time > 2*PI: time = time - 2*PI
	bottom.shape.distance = -340/zoom.x
	top.shape.distance = -340/zoom.x
	right.shape.distance = -600/zoom.x
	left.shape.distance = -600/zoom.x
	zoom.x += 0.01*mult*cos(time)
	zoom.y = zoom.x
	if Global.INGAME: mult = 0.1
	else: mult = 0.03
