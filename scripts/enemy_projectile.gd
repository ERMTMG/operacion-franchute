extends CharacterBody2D
class_name EnemyProjectile

@onready var flash := preload("res://vfx_scenes/small_flash.tscn")
@onready var hitSound := preload("res://sounds/enemy_hit.wav")
@onready var blastSound := preload("res://sounds/explosion01.wav")


@export var speed: float
@export var direction: float
@export var damageDealt: int

func _ready() -> void:
	assert(get_parent() is Game)
	Global.PROJECTILECOUNT += 1
	if Global.PROJECTILECOUNT > Global.MAXPROJECTILECOUNT:
		queue_free()
	global_rotation = direction

func _exit_tree() -> void:
	Global.PROJECTILECOUNT -= 1

func _physics_process(delta: float) -> void:
	global_rotation = direction
	velocity = speed * Vector2.from_angle(direction)
	var collided: bool = move_and_slide()
	if collided:
		var totalNumCollisions := get_slide_collision_count()
		for i in totalNumCollisions:
			var collision: KinematicCollision2D = get_slide_collision(i)
			if collision.get_collider() is Player:
				var player := collision.get_collider() as Player
				player.hurt(damageDealt, true)
				hit()
			elif collision.get_collider() is Laser:
				var playerLaser := collision.get_collider() as Laser
				playerLaser.hit_enemy()
				Global.create_vfx(flash, collision.get_position())
				Global.GAME_MANAGER.play_sfx(blastSound)
				hit()

func hit() -> void:
	Global.GAME_MANAGER.play_sfx(hitSound)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
