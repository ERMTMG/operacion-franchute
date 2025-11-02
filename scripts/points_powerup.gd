extends PowerUp
class_name PointsPowerUp

@export var pointsGiven: int
@export var starVfxSpawned: int
@export var textPopupTexture: Texture2D
@onready var textNotifScene: PackedScene = preload("res://vfx_scenes/text_notif_generic.tscn")
@onready var colorStarScene: PackedScene = preload("res://vfx_scenes/color_star.tscn")
@onready var moneySound: AudioStream = preload("res://sounds/cling.wav")

func collected_by_player(player: Player):
	if !is_queued_for_deletion():
		Global.GAME_MANAGER.play_sfx(moneySound, true, 1.33)
		var textNotifEffect: Sprite2D = textNotifScene.instantiate()
		textNotifEffect.texture = textPopupTexture
		Global.create_vfx_from_node(textNotifEffect, global_position, false, true)
		for i in starVfxSpawned:
			Global.create_vfx(colorStarScene, global_position)
	super(player)
