extends Sprite2D

var timer: int = 0
const FLASH_START_FRAMES: int = 15
const FLASH_LOOP_FRAMES: int = 25

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	timer += 1
	if timer == FLASH_START_FRAMES && Settings.ENEMY_FLASH_ENABLED:
		(material as ShaderMaterial).set_shader_parameter("enabled", true)
	elif timer == FLASH_LOOP_FRAMES:
		(material as ShaderMaterial).set_shader_parameter("enabled", false)
		timer = 0
