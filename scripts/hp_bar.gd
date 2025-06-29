extends CanvasGroup
class_name HPBar
@onready var full = $full
@export var bar_size = 100
@onready var maxwidth = $black.size.x
@export var color_scale = false
var width
var parent: Enemy

func _ready():
	$border.size.x = bar_size
	$black.size.x = bar_size - 8
	$border.position.x = -bar_size/2
	$black.position.x = -(bar_size/2) + 4
	$full.position.x = -(bar_size/2) + 4
	maxwidth = $black.size.x
	if get_parent() is not Enemy:
		queue_free()
	else:
		parent = get_parent()
		

func _process(delta):
	if parent.health == parent.maxHealth || !parent.showHP:
		visible = false
	else:
		visible = true
		global_rotation = 0
		global_position = parent.global_position
		global_position.y += parent.HP_BAR_POS * parent.global_scale.y
		global_scale = Vector2(1,1)
		width = (1.0*parent.health / parent.maxHealth)*maxwidth
		full.size.x = width
		var hue: float
		if Settings.RAINBOW_HP_BARS_ENABLED:
			hue =  (Global.GLOBAL_TIMER % 150) / 150.0
		elif color_scale: 
			hue = (1.0*parent.health) / (3.0*parent.maxHealth)
		else:
			hue = 0.333333333333
		full.color = Color.from_hsv(hue, 0.92, 0.94)
