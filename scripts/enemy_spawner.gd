extends Node
class_name EnemySpawner

@onready var genericEnemy: PackedScene = preload("res://enemy.tscn")
@onready var croissant: PackedScene = preload("res://croissant.tscn")
@onready var baguette: PackedScene = preload("res://baguette.tscn")
@onready var robossant: PackedScene = preload("res://robossant.tscn")
@onready var wineBottle: PackedScene = preload("res://wine_bottle.tscn")

const RandRange = Utils.RandRange
const RandRangeInt = Utils.RandRangeInt

enum {
	POINT_RANDOM,
	POINT_PLAYER,
	POINT_CUSTOM
}
class EnemySpawn:
	var enemyScene: PackedScene
	var size: RandRange
	var speed: RandRange
	var hp: RandRangeInt
	var spinSpeed: RandRange
	var pointingType: int
	var direction: float
	var count: int
	
	func _init(enemyScene: PackedScene) -> void:
		self.enemyScene = enemyScene
	
	static func create(enemyScene: PackedScene, health, speed, size,
	  spinSpeed, pointType: int, direction: float = 0, count: int = 1) -> EnemySpawn:
		var created: EnemySpawn = EnemySpawn.new(enemyScene)
		
		assert(health is Utils.RandRangeInt || typeof(health) == TYPE_INT)
		if health is Utils.RandRangeInt:
			created.hp = health
		else:
			created.hp = Utils.range_i(health, health)
			
		assert(speed is Utils.RandRange || typeof(speed) == TYPE_FLOAT)
		if speed is Utils.RandRange:
			created.speed = speed
		else:
			created.speed = Utils.range_f(speed, speed)
		
		assert(size is Utils.RandRange || typeof(size) == TYPE_FLOAT)
		if size is Utils.RandRange:
			created.size = size
		else:
			created.size = Utils.range_f(size, size)
		
		assert(spinSpeed is Utils.RandRange || typeof(spinSpeed) == TYPE_FLOAT)
		if spinSpeed is Utils.RandRange:
			created.spinSpeed = spinSpeed
		else:
			created.spinSpeed = Utils.range_f(spinSpeed, spinSpeed)
		
		created.pointingType = pointType
		created.direction = direction
		created.count = count
		
		return created
	
	func get_enemy() -> Enemy:
		var output: Enemy = enemyScene.instantiate()
		output.scale = self.size.get_val() * Vector2.ONE
		output.speed = self.speed.get_val()
		output.maxHealth = self.hp.get_val()
		output.spinSpeed = self.spinSpeed.get_val()
		match pointingType:
			POINT_RANDOM:
				output.direction = randf() * TAU
			POINT_PLAYER:
				var playerPos = Global.GAME_MANAGER.get_player_position()
				if playerPos != null and playerPos is Vector2:
					output.direction = (-playerPos).angle()
				else:
					output.direction = randf() * TAU
			POINT_CUSTOM:
				output.direction = self.direction
		return output
	
	func get_enemies() -> Array[Enemy]:
		var output : Array[Enemy] = []
		var angleDiff: float = TAU / self.count
		var rand: float = randf() * TAU
		for i in self.count:
			var currEnemy := get_enemy()
			if self.pointingType == POINT_RANDOM:
				currEnemy.direction = rand + i*angleDiff
			output.append(currEnemy)
		return output
	
	func spawn_as_child_of(node: Node) -> void:
		for enemy in self.get_enemies():
			node.add_child(enemy)
		
static func get_enemy_spawn_from_enemy_spawning_chance_array(chanceArray: Utils.ChanceArray) -> EnemySpawn:
	var obj: Object = chanceArray.get_random()
	if obj is EnemySpawn:
		return obj as EnemySpawn
	elif obj is Utils.ChanceArray:
		return get_enemy_spawn_from_enemy_spawning_chance_array(obj as Utils.ChanceArray)
	else:
		push_error("Unknown object type received from chance array")
		return null
#func spawn_enemy_30s_60s() -> EnemySpawn:
	#if randi() % 2 == 0:
		#return EnemySpawn.create(croissant, 15, [1.0,3.0], 1.0, [.008,.012], POINT_RANDOM)
	#else:
		#return EnemySpawn.create(baguette, 30, [5.0,7.5], 1.0, 0.0, POINT_PLAYER)
#
#func spawn_enemy_60s_100s() -> Variant:
	#if randi() % 4 == 0: # 25% chance
		#return EnemySpawn.create(robossant, 30, [1.0,2.5], 1.0, [.006,.01], POINT_RANDOM)
	#else: # 75% chance
		#var rand1: int = randi_range(1,5)
		#if rand1 > 3: # 40% chance
			#return EnemySpawn.create(croissant, 15, [1.0,3.0], 1.0, [.008,.012], POINT_RANDOM)
		#elif rand1 < 3: # 40% chance
			#return EnemySpawn.create(baguette, 20, [7.5,10], 1.0, 0.0, POINT_PLAYER)
		#else:
			#if randi() % 2 == 0:
				#var direction: float = randf() * TAU
				#return [
					#EnemySpawn.create(croissant, 15, [0.5, 1.5], 0.8, [.0075,.01], POINT_CUSTOM, direction),
					#EnemySpawn.create(croissant, 15, [0.5, 1.5], 0.8, [.0075,.01], POINT_CUSTOM, direction + PI),
				#]
			#else:
				#return EnemySpawn.create(wineBottle, 3, [3.0,6.0], [0.75,1.0], [.01,.02], POINT_RANDOM)

#func spawn_enemy() -> EnemySpawn:
	#return EnemySpawn.new(croissant, [1.2,1.5], [1.5,2.5], [18,24], [0.008,0.013], POINT_RANDOM)
