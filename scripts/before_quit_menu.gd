extends TextureRect

const MENU_SHOW_TRANSITION_WEIGHT: float = 0.5

func _ready() -> void:
	visible = false

func _physics_process(delta):
	if visible:
		scale = scale.lerp(Vector2.ONE, MENU_SHOW_TRANSITION_WEIGHT)
	else:
		scale = Vector2.ZERO

func _on_save_button_pressed() -> void:
	SaveManager.serialize_and_save_game()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_dont_save_button_pressed() -> void:
	SaveSystem.set_clear_data(true)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_dont_quit_button_pressed() -> void:
	visible = false
