extends LevelButton

@onready var label = $Label;

func on_set_level():
	label.text = "Secret %d" % [abs(level_index)]; 

func _on_select_triggered() -> void:
	if !is_active:
		return;
	emit_signal("selected", level_index);
