extends GlowNode
class_name LevelButton

signal selected(level_index)

var level_index : int;
var is_active : bool = true;

func set_level(level : int):
	level_index = level;
	on_set_level();

func on_set_level():
	pass;

func toggle_active(value : bool = true):
	is_active = value;

func deactivate():
	full_shutter();
	toggle_active(false);
