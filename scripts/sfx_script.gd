extends AudioStreamPlayer
class_name AudioSFX

var deletesignal = Callable(self, "delete")

func _init() -> void: pass

func _ready():
	play()

func delete():
	queue_free()

func _process(delta):
	pass
