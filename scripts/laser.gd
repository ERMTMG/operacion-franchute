extends CharacterBody2D
class_name Laser

@export_group("Bullet Properties")
@export var speed: float
@export var direction: float
@export var damage: int

@export_group("Node and Scene Connections")
@export_file var myScenePath: String
@onready var myScene: PackedScene
@export var hitSounds: Array[AudioStream] = [preload("res://sounds/enemy_hit.wav"), preload("res://sounds/enemy_hit2.wav"), preload("res://sounds/enemy_hit3.wav")]

func _ready() -> void:
	assert(get_parent() is Game)
	myScene = load(myScenePath)
	Global.PROJECTILECOUNT += 1
	if Global.PROJECTILECOUNT > Global.MAXPROJECTILECOUNT:
		queue_free()
	global_rotation = direction

func _exit_tree() -> void:
	Global.PROJECTILECOUNT -= 1

func _physics_process(delta: float) -> void:
	velocity = speed * Vector2.from_angle(direction)
	move_and_slide()

func hit_enemy() -> void:
	var playedSfx: AudioStream = hitSounds.pick_random()
	get_parent().play_sfx(playedSfx, 1.2)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
