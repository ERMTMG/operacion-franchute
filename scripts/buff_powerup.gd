extends PowerUp
class_name BuffPowerUp


@export var buffTime: int = 900 # in frames
@export var buffType := Global.BuffTypes.MULTISHOT_BUFF
@onready var smallRays: PackedScene = preload("res://vfx_scenes/small_rays.tscn")

func collected_by_player(player: Player):
	if !is_queued_for_deletion():
		Global.create_vfx(smallRays, global_position)
	super(player)
