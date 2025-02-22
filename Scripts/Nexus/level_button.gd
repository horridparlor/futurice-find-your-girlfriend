extends LevelButton

@onready var label : Label = $Label;

func _ready() -> void:
	activate_animations();

func on_set_level():
	label.text = str(level_index + 1);

func _on_select_triggered() -> void:
	if !is_active:
		return;
	emit_signal("selected", level_index);
