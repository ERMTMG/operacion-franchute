extends PowerUp
class_name ToolBoxPowerUp

@export var maxHealthIncrease: int = 20
@export_range(0.0, 1.0, 0.01) var additionalHealingFactor: float = 0.1

@onready var rays: PackedScene = preload("res://vfx_scenes/small_rays.tscn")

func collected_by_player(player: Player) -> void:
	if !is_queued_for_deletion():
		# TODO: add a hammering-nails sound, or a drill,or maybe both at random 
		Global.create_vfx(rays, player.global_position)
	super(player)
