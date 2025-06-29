extends TextureRect
var time = 0

func _physics_process(delta):
	if get_parent().visible:
		global_position.y = -50 + 15*sin(time*0.015)
		time += 1
		if time < 100:
			modulate = Color(1,1,1,time / 100.0)
	else:
		time = 0
