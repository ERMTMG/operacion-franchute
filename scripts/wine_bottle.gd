extends Enemy
class_name WineBottle

@onready var wineSplashEffect: PackedScene = preload("res://vfx_scenes/wine_splash.tscn")
@onready var largeFlashEffect: PackedScene = preload("res://vfx_scenes/largeflash.tscn")
@onready var bottleShardScene: PackedScene = preload("res://wine_bottle_shard.tscn")
@onready var shatterSound: AudioStream = preload("res://sounds/shatter_large.wav")


func split_into_shards(number: int, speedRange: Array[float], spinRange: Array[float], sizeRange: Array[float]):
	_split_ranges(bottleShardScene, number, speedRange, spinRange, sizeRange, [1,1])

func check_player() -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.hurt(damage, true)
			die()

func die() -> void:
	if !is_queued_for_deletion():
		_play_sound(shatterSound, 1.25)
		Global.create_vfx(largeFlashEffect, global_position)
		var inScreenPosition: Vector2 = get_global_transform_with_canvas().origin
		Global.create_vfx(wineSplashEffect, inScreenPosition, true, true)
		split_into_shards(randi_range(16, 24), [1*speed, 2*speed], [spinSpeed, spinSpeed], [0.666*scale.x, scale.x])
	super()
