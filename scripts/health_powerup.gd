extends PowerUp
class_name HealthPowerUp

@export var healthGiven: int
@onready var smallRays = preload("res://vfx_scenes/small_rays.tscn")

func collected_by_player(player: Player) -> void:
	if !is_queued_for_deletion():
		Global.create_vfx(smallRays, global_position)
	super(player)
