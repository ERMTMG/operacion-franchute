class_name EnemyJSON

static func parse_enemy_spawning_rules_from_json_file(filePath: String) -> Variant:
	if !filePath.ends_with(".json"):
		push_warning("Filename doesn't correspond to a JSON file. Yikes!")
	var jsonString: String = FileAccess.get_file_as_string(filePath)
	var json := JSON.new()
	var jsonError = json.parse(jsonString)
	if jsonError != OK:
		var line := json.get_error_line()
		var error := json.get_error_message()
		push_error("Error parsing at line %d: %s" % [line, error])
	var jsonDict = json.data
	var obj = deserialize_json_item(jsonDict as Dictionary)
	return obj

static func deserialize_json_item(jsonDict: Dictionary) -> Variant:
	var type: String = jsonDict.get("TYPE", "")
	match type:
		"":
			push_error("Type not declared")
			return null
		"ENEMYSPAWN":
			return enemy_from_dict(jsonDict)
		"CHOICES":
			return chance_array_from_dict(jsonDict)
		"INTERVALS":
			return get_interval_mapping_from_dict(jsonDict)
		_:
			push_error("Unrecognized object type in dictionary")
			return null

static func get_interval_mapping_from_dict(jsonDict: Dictionary) -> Dictionary[float, Object]:
	var map: Dictionary[float, Object] = {}
	if jsonDict.get("TYPE", "") != "INTERVALS":
		push_error("Given dictionary doesn't correspond to a time interval mapping")
	else:
		jsonDict.erase("TYPE")
		for key in jsonDict:
			var timestamp: float = float(key)
			var subDict: Dictionary = jsonDict[key]
			var mappedObject = deserialize_json_item(subDict)
			map.set(timestamp, mappedObject)
	return map

static func chance_array_from_dict(jsonDict: Dictionary) -> Utils.ChanceArray:
	if jsonDict.get("TYPE", "") != "CHOICES":
		push_error("Given dictionary doesn't correspond to a multiple-choice decision")
	else:
		var choices = jsonDict.get("choices")
		if choices == null || choices is not Array:
			push_error("Invalid or nonexistent choices")
		else:
			var choicesArray := choices as Array
			var choicesForCtor: Array[Array] = []
			for choice: Dictionary in choicesArray:
				var chance: float = choice.get("chance", 0.0)
				if chance == 0.0:
					push_warning("Invalid chance on parsed chance array - unreachable")
				var object: Object = deserialize_json_item(choice)
				if object != null:
					choicesForCtor.push_back([object, chance])
				else:
					push_warning("Invalid or null object in parsed chance array")
			return Utils.chance_array(choicesForCtor)
	return null 

# working with json dictionaries is impossible to do type-safe-ly apparently
static func enemy_from_dict(jsonDict: Dictionary) -> EnemySpawner.EnemySpawn:
	if jsonDict.get("TYPE", "") != "ENEMYSPAWN":
		push_error("Given dictionary doesn't correspond to an enemy spawn")
	else:
		var enemyKey: String = jsonDict.get("enemyType", "")
		var enemyScene: PackedScene = ENEMY_PACKED_SCENES[enemyKey]
		if enemyScene == null: push_error("Unknown or nonexistent enemy key")
		
		var size = jsonDict.get("size")
		if size == null:
			push_error("Size not given")
		elif size is Array:
			size = Utils.range_f(size[0], size[1])
		else:
			size = size as float
		
		var hp = jsonDict.get("hp")
		if hp == null:
			push_error("Health not given")
		elif hp is Array:
			hp = Utils.range_i(hp[0], hp[1])
		else:
			hp = hp as int
			
		var speed = jsonDict.get("speed")
		if speed == null:
			push_error("Speed not given")
		elif speed is Array:
			speed = Utils.range_f(speed[0], speed[1])
		else:
			speed = speed as float
		
		var spinSpeed = jsonDict.get("spinSpeed")
		if spinSpeed == null:
			push_error("Spin speed not given")
		elif spinSpeed is Array:
			spinSpeed = Utils.range_f(spinSpeed[0], spinSpeed[1])
		else:
			spinSpeed = spinSpeed as float
		
		var direction = jsonDict.get("direction")
		var dirEnumValue: int
		if direction == null:
			push_error("Direction not given")
		elif direction is String:
			match direction as String:
				"random": dirEnumValue = EnemySpawner.POINT_RANDOM
				"player": dirEnumValue = EnemySpawner.POINT_PLAYER
			direction = 0.0
		else:
			dirEnumValue = EnemySpawner.POINT_CUSTOM
		var count = jsonDict.get("count")
		if count == null:
			count = 1
		return EnemySpawner.EnemySpawn.create(
			enemyScene, hp, speed, size, spinSpeed, dirEnumValue, direction, count
		)
		
	return null # UNREACHABLE
	
const ENEMY_PACKED_SCENES: Dictionary[String, PackedScene] = {
	"croissant"  : preload("res://croissant.tscn"),
	"baguette"   : preload("res://baguette.tscn"),
	"robossant"  : preload("res://robossant.tscn"),
	"winebottle" : preload("res://wine_bottle.tscn"),
	"croissatan" : preload("res://croissatan.tscn"),
	
	"" : null
}
