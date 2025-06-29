extends TextureRect

var gameManager: Game = Global.GAME_MANAGER
const MENU_SHOW_TRANSITION_WEIGHT: float = 0.5
const SKIN_PREVIEW_ROTATION_SPEED: float = 1
@export var animationPlayer: AnimationPlayer
@export var skinNameLabel: RichTextLabel
@export var skinPreview: TextureRect
@export var skinPreviewSparkles: GPUParticles2D
@export var selectButton: SkinSelectButton
@export var colorMenu: TextureRect
const LABEL_POS: Vector2 = Vector2(194,49)
const SKIN_MENU_SOUNDS: Dictionary[StringName, AudioStream] = {
	&"WINDOW_POPUP": preload("res://sounds/menu/window_popup.mp3"),
	&"WINDOW_CLOSE": preload("res://sounds/menu/window_close.wav"),
	&"CHECKBOX_TAP": preload("res://sounds/menu/checkbox_tap.mp3"),
	&"BUTTON_PRESS": preload("res://sounds/menu/button_press.wav"),
	&"BUTTON_DENY" : preload("res://sounds/menu/button_deny.mp3")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _draw() -> void: pass
	
func manage_skin_label_size(skinName: String) -> void:
	const DEFAULT_SIZE: Vector2 = Vector2(300, 50)
	skinNameLabel.text = "[center]" + skinName
	skinNameLabel.size = DEFAULT_SIZE
	skinNameLabel.scale = Vector2.ONE
	while skinNameLabel.get_line_count() > 1:
		skinNameLabel.size.x += 50
	skinNameLabel.scale.x = DEFAULT_SIZE.x / skinNameLabel.size.x

func refresh_skin() -> void:
	var skinName : String = PlayerSkins.get_skin_name(PlayerSkins.CURRENT_SKIN_SHOWING)
	manage_skin_label_size(skinName)
	skinPreview.texture = PlayerSkins.get_skin_texture(PlayerSkins.CURRENT_SKIN_SHOWING)
	selectButton.change_texture(PlayerSkins.CURRENT_SKIN_SHOWING)
	if PlayerSkins.supports_color(PlayerSkins.CURRENT_SKIN_SHOWING):
		colorMenu.show()
	else:
		colorMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if gameManager == null: gameManager = Global.GAME_MANAGER 
	if visible:
		scale = scale.lerp(Vector2.ONE, MENU_SHOW_TRANSITION_WEIGHT)
	else:
		scale = Vector2.ZERO
	skinPreview.rotation_degrees += SKIN_PREVIEW_ROTATION_SPEED
	skinPreviewSparkles.emitting = PlayerSkins.is_skin_sparkle(PlayerSkins.CURRENT_SKIN_SHOWING)
	if (PlayerSkins.is_skin_rainbow(PlayerSkins.CURRENT_SKIN_SHOWING) \
	  && Global.CURRENT_MENU_SHOWING == Global.SKINS_MENU) \
	  || PlayerSkins.is_skin_rainbow(PlayerSkins.CURRENT_PLAYER_SKIN):
		var hue: float = remap(1.0*(Global.GLOBAL_TIMER % 180), 0.0, 180.0, 0, 1.0)
		skinPreview.material.set_shader_parameter("Shift_Hue", hue)
	else:
		skinPreview.material.set_shader_parameter("Shift_Hue", PlayerSkins.ACTUAL_SKIN_HUE_SHIFT)

func _on_skin_menu_button_pressed() -> void:
	if Global.CURRENT_MENU_SHOWING == Global.NONE:
		refresh_skin()
		visible = true
		gameManager.play_sfx(SKIN_MENU_SOUNDS["WINDOW_POPUP"])
		Global.CURRENT_MENU_SHOWING = Global.SKINS_MENU

func _on_quit_button_pressed() -> void:
	gameManager.play_sfx(SKIN_MENU_SOUNDS["WINDOW_CLOSE"])
	Global.CURRENT_MENU_SHOWING = Global.NONE
	visible = false

func _on_select_button_pressed() -> void:
	animationPlayer.play("RESET")
	if PlayerSkins.is_shown_skin_currently_selectable():
		gameManager.play_sfx(SKIN_MENU_SOUNDS["BUTTON_PRESS"])
		animationPlayer.play("selectButtonClick")
		PlayerSkins.set_skin()
	else:
		gameManager.play_sfx(SKIN_MENU_SOUNDS["BUTTON_DENY"])
		animationPlayer.play("selectButtonDeny")
	refresh_skin()

func _on_button_switch_page_right_pressed() -> void:
	animationPlayer.play("RESET")
	gameManager.play_sfx(SKIN_MENU_SOUNDS["BUTTON_PRESS"])
	animationPlayer.play("switchPageRight")
	PlayerSkins.show_next_skin()
	refresh_skin()

func _on_button_switch_page_left_pressed() -> void:
	animationPlayer.play("RESET")
	gameManager.play_sfx(SKIN_MENU_SOUNDS["BUTTON_PRESS"])
	animationPlayer.play("switchPageLeft")
	PlayerSkins.show_prev_skin()
	refresh_skin()

func _on_hue_increase_button_pressed() -> void:
	animationPlayer.play("RESET")
	gameManager.play_sfx(SKIN_MENU_SOUNDS["BUTTON_PRESS"])
	animationPlayer.play("hueIncreaseButtonClick")
	PlayerSkins.increase_skin_hue_shift()

func _on_hue_decrease_button_pressed() -> void:
	animationPlayer.play("RESET")
	gameManager.play_sfx(SKIN_MENU_SOUNDS["BUTTON_PRESS"])
	animationPlayer.play("hueDecreaseButtonClick")
	PlayerSkins.decrease_skin_hue_shift()
