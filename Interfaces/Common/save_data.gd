extends Node
class_name SaveData

var levels_unlocked : int;

func _init(_levels_unlocked : int = 0) -> void:
	levels_unlocked = _levels_unlocked;

static func from_json(data : Dictionary) -> SaveData:
	return SaveData.new(
		data.levelsUnlocked
	);

func to_json() -> Dictionary:
	return {
		"levelsUnlocked": levels_unlocked
	}
