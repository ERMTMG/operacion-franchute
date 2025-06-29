extends Enemy
class_name WineBottleShard

@onready var smallFlashScene: PackedScene = preload("res://vfx_scenes/small_flash.tscn")
@onready var shatterSounds: Array[AudioStream] = [
	preload("res://sounds/shatter_small0.wav"),
	preload("res://sounds/shatter_small1.wav")
]
func die() -> void:
	_play_sound(shatterSounds.pick_random())
	Global.create_vfx(smallFlashScene, global_position)
	super()
