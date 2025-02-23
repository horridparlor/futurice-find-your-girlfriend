extends Node
class_name SaveData

const DEFAULT_LEVELS_UNLOCKED : int = 0;

const DEFAULT_SECRECTS_UNLOCKED : Dictionary = {
	-1: false,
	-2: false,
	-3: false
}

var levels_unlocked : int;
var previous_level_selected : int;
var secrets_unlocked : Dictionary;

func _init(levels_unlocked_ : int = DEFAULT_LEVELS_UNLOCKED,
secrets_unlocked_ : Dictionary = DEFAULT_SECRECTS_UNLOCKED) -> void:
	levels_unlocked = levels_unlocked_;
	secrets_unlocked = secrets_unlocked_
	previous_level_selected = levels_unlocked;

static func from_json(data : Dictionary) -> SaveData:
	return SaveData.new(
		System.Dictionaries.safe_get(data, "levelsUnlocked", DEFAULT_LEVELS_UNLOCKED),
		System.Dictionaries.safe_get(data, "secretsUnlocked", DEFAULT_SECRECTS_UNLOCKED)
	);

func to_json() -> Dictionary:
	return {
		"levelsUnlocked": levels_unlocked,
		"secretsUnlocked": secrets_unlocked
	}
