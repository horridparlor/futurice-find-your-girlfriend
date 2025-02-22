extends Enemy

@onready var color_rect : ColorRect = $ColorRect;

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Halo"):
		color_rect.color = PINK_COLOR if is_girlfriend() else YELLOW_COLOR;
	elif area.is_in_group("Player"):
		emit_signal("player_hit", is_girlfriend());
