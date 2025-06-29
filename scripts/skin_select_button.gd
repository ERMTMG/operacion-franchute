extends Button
class_name SkinSelectButton

@export var sprite: Sprite2D
enum {
	BUTTON_AVAILABLE = 0,
	BUTTON_SELECTED = -1,
	BUTTON_LOCKED_5K = 5000,
	BUTTON_LOCKED_10K = 10000,
	BUTTON_LOCKED_20K = 20000,
	BUTTON_LOCKED_25K = 25000,
	BUTTON_LOCKED_30K = 30000,
	BUTTON_LOCKED_50K = 50000
}

const BUTTON_TEXTURES: Dictionary[int, Texture] = {
	BUTTON_AVAILABLE:  preload("res://sprites/menu/skin_menu_select_button.svg"),
	BUTTON_SELECTED:   preload("res://sprites/menu/skin_menu_selected_button.svg"),
	BUTTON_LOCKED_5K:  preload("res://sprites/menu/skin_menu_locked_5k_button.svg"),
	BUTTON_LOCKED_10K: preload("res://sprites/menu/skin_menu_locked_10k_button.svg"),
	BUTTON_LOCKED_20K: preload("res://sprites/menu/skin_menu_locked_20k_button.svg"),
	BUTTON_LOCKED_25K: preload("res://sprites/menu/skin_menu_locked_25k_button.svg"),
	BUTTON_LOCKED_30K: preload("res://sprites/menu/skin_menu_locked_30k_button.svg"),
	BUTTON_LOCKED_50K: preload("res://sprites/menu/skin_menu_locked_50k_button.svg"),
}

func change_texture(skinIdx: int) -> void:
	if PlayerSkins.CURRENT_PLAYER_SKIN == skinIdx:
		sprite.texture = BUTTON_TEXTURES[BUTTON_SELECTED]
	elif PlayerSkins.is_skin_currently_selectable(skinIdx):
		sprite.texture = BUTTON_TEXTURES[BUTTON_AVAILABLE]
	else:
		var skinPointsRequired: int = PlayerSkins.get_skin_points_needed(skinIdx)
		sprite.texture = BUTTON_TEXTURES[skinPointsRequired]

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
