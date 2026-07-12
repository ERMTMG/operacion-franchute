extends Node
class_name ComboManager

class ComboEntry:
	var scoreMultiplier: float
	var timeWindowSecs: float
	func _init(timeWindowSecs: float, scoreMultiplier: float) -> void:
		self.timeWindowSecs = timeWindowSecs;
		self.scoreMultiplier = scoreMultiplier;

const MAX_COMBO := 7
static var COMBO_DATA: Dictionary[int, ComboEntry] = {
	0: ComboEntry.new(3.0, 1.00),
	1: ComboEntry.new(5.0, 1.10),
	2: ComboEntry.new(5.0, 1.15),
	3: ComboEntry.new(4.75, 1.20),
	4: ComboEntry.new(4.5, 1.30),
	5: ComboEntry.new(4.0, 1.40),
	6: ComboEntry.new(3.5, 1.50),
	7: ComboEntry.new(3.25, 1.75),
}

static func _static_init() -> void:
	COMBO_DATA.make_read_only()

@export var _comboTimer: Timer
var _currentCombo: int = 0
signal combo_changed(newComboValue: int)

func _ready() -> void:
	_comboTimer.wait_time = COMBO_DATA[0].timeWindowSecs

func _set_combo(comboValue: int) -> void:
	if comboValue < 0: return
	if comboValue <= MAX_COMBO:
		_currentCombo = comboValue
	combo_changed.emit(_currentCombo)
	_comboTimer.wait_time = get_current_combo_time_window()

func _increment_combo() -> void:
	_set_combo(_currentCombo + 1)

func on_enemy_died() -> void:
	if not _comboTimer.is_stopped():
		_increment_combo()
	_comboTimer.start()

func on_weak_enemy_died(timeIncrement: float) -> void:
	_comboTimer.start(_comboTimer.time_left + timeIncrement)

func _on_combo_timer_timeout() -> void:
	_set_combo(0)
	

func get_current_combo_time_window() -> float:
	return COMBO_DATA[_currentCombo].timeWindowSecs

func get_current_score_multiplier() -> float:
	return COMBO_DATA[_currentCombo].scoreMultiplier

func get_current_combo_time_left() -> float:
	return _comboTimer.time_left
