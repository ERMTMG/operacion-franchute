extends Label
var string: String = ""
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("activate debug mode"):
		visible = !visible
	if !visible: return
	var menu_showing_text: String
	match Global.CURRENT_MENU_SHOWING:
		Global.NONE:
			menu_showing_text = "None"
		Global.OPTIONS_MENU:
			menu_showing_text = "Options menu"
		Global.SKINS_MENU:
			menu_showing_text = "Skins menu"
		Global.BEFORE_QUIT_POPUP:
			menu_showing_text = "Begore quitting popup"
		Global.HISH_SCORE_BEAT_POPUP:
			menu_showing_text = "High score beat popup"
		_:
			menu_showing_text = "???"
	string =  "DEBUG INFO \n"
	string += "    Global Variables:\n"
	string += "        PlayerHealth = %d\n" % Global.PLAYERHEALTH
	string += "        PlayerMaxHealth = %d\n" % Global.PLAYERMAXHEALTH
	string += "        InGame = %s\n" % Global.INGAME
	string += "        GameTime = %.1f\n" % Global.GAMETIME
	string += "        EnemyCount = %d / %d \n" % [Global.ENEMYCOUNT, Global.MAXENEMYCOUNT]
	string += "        PowerupCount = %d / %d\n" % [Global.POWERUPCOUNT, Global.MAXPOWERUPCOUNT]
	string += "        ProjectileCount = %d / %d\n" % [Global.PROJECTILECOUNT, Global.MAXPROJECTILECOUNT]
	string += "        AmmoBuffTime = %d \n" % Global.get_buff_time(Global.BuffTypes.AMMO_BUFF)
	string += "        HighScore = %d \n" % Global.HIGH_SCORE
	string += "        GlobalTimer = %d \n" % Global.GLOBAL_TIMER
	string += "        CurrentMenuShowing = %s \n" % menu_showing_text
	var root: Node = get_tree().current_scene
	if root is Game and Global.INGAME:
		string += "    PlayerPosition = %s\n" % root.get_player_position()
	if root.get_node("Camera2D") is Camera2D:
		string += "    CameraZoom = %.5f\n" % root.get_node("Camera2D").zoom.x
	string += "    Timers:\n"
	if root.get_node("GameTimer") is Timer:
		string += "        GameTimerValue = %.3f\n" % root.get_node("GameTimer").time_left
	if root.get_node("EnemyTimer") is Timer:
		string += "        EnemyTimerValue = %.3f\n" % root.get_node("EnemyTimer").time_left
	text = string 
