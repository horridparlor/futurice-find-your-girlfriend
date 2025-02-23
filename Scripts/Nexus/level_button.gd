extends LevelButton

@onready var label : Label = $Label;
@onready var final_stage_panel : Panel = $FinalStagePanel;

func on_set_level():
	label.text = str(level_index + 1);
	if level_index == GameplayEnums.LAST_LEVEL:
		final_stage_panel.visible = true;

func _on_select_triggered() -> void:
	if !is_active:
		return;
	emit_signal("selected", level_index);
