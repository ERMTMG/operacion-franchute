extends Node

class RandRange:
	var min: float
	var max: float
	
	func _init(min: float, max: float) -> void:
		self.min = min
		self.max = max
	
	func _to_string() -> String:
		return "[%f-%f]" % [min, max]
	
	func get_val() -> float:
		return randf_range(min, max)

func range_f(min: float, max: float) -> RandRange:
	return RandRange.new(min, max)

class RandRangeInt:
	var min: int
	var max: int
	
	func _init(min: int, max: int) -> void:
		self.min = min
		self.max = max
		
	func get_val() -> int:
		return randi_range(min, max)
	
	func _to_string() -> String:
		return "[%d-%d]" % [min, max]

func range_i(min: int, max: int) -> RandRangeInt:
	return RandRangeInt.new(min, max)

class ChanceArray:
	var choices: Array
	var chances: Array[float]
	var default: Variant
	
	func _init(choices: Array, chances: Array[float], default: Variant = null) -> void:
		self.choices = choices
		self.chances = chances
		self.default = default
	
	func _get_sum_of_chances() -> float:
		if chances.is_empty(): return 0
		else: 
			var sum := func(a: float, b: float) -> float: return a + b
			return chances.reduce(sum)
	
	func push(object: Variant, chance: float) -> void:
		if chance < 0.0 || chance > 1.0:
			push_error("Invalid chance value (%f)" % chance)
		elif _get_sum_of_chances() + chance > 1.0:
			push_warning("Sum of chances exceeds 1")
		else:
			choices.append(object)
			chances.append(chance)
	
	func set_default(default: Variant) -> void:
		self.default = default
	func get_default() -> Variant:
		return self.default
	
	func normalize() -> void:
		var total := _get_sum_of_chances()
		if total > 1.0:
			for chance in chances: 
				chance /= total
	
	func get_random() -> Variant:
		var p: float = randf()
		var output: Variant = self.default
		for i in choices.size():
			if(p < chances[i]):
				return choices[i]
			p -= chances[i]
		return output
	
	func _to_string() -> String:
		var output: String = "ChanceArray[\n\t"
		for i in choices.size():
			if i != 0:
				output += ",\n\t"
			output += str(self.chances[i]) + " chance of " + str(choices[i])
		output += "\n]"
		return output

func chance_array(elements: Array[Array], default: Variant = null):
	var output := ChanceArray.new([], [], default)
	for element: Array in elements:
		if element.size() == 2 && typeof(element[1] == TYPE_FLOAT):
			output.push(element[0], element[1])
		else:
			push_error("Invalid element in ChanceArray initializator")
	return output
	
