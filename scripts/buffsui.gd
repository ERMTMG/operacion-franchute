extends Control
const RECTSIZE: int = 40
const BUFFDURATION: float = 900.0
@onready var BUFF_ICONS: Array[Control] = [
	$ammobuff,
	$bluelaserbuff,
]
@onready var BUFF_FILL_RECTS: Array[ColorRect] = [
	$ammobuff/fill,
	$bluelaserbuff/fill,
]

func is_buff_id_in_range(buffIdx) -> bool:
	return (0 <= buffIdx &&\
			buffIdx < BUFF_ICONS.size() &&\
			buffIdx < BUFF_FILL_RECTS.size()) 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in range(Global.BUFF_TIMES.size()):
		if is_buff_id_in_range(i):
			var buffTime: int = Global.get_buff_time(i);
			if buffTime == 0:
				BUFF_ICONS[i].hide()
			else:
				BUFF_ICONS[i].show()
				BUFF_FILL_RECTS[i].size.x = (buffTime/BUFFDURATION) * RECTSIZE
