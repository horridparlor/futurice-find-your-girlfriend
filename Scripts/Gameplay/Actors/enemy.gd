extends Enemy

@onready var color_rect : ColorRect = $ColorRect;
@onready var collision_box : CollisionShape2D = $HitBox/CollisionShape2D;

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Halo"):
		color_rect.color = PINK_COLOR if is_girlfriend() else YELLOW_COLOR;
		if is_hit:
			on_death();	
		is_hit = true;
	elif area.is_in_group("Player"):
		emit_signal("player_hit", is_girlfriend());
	elif area.is_in_group("Monster"):
		on_death();

func scale_up(multiplier : float) -> void:
	size_class *= multiplier;
	collision_box.shape.size = Vector2(abs(size_class), abs(size_class));
	color_rect.size *= multiplier;
	color_rect.position = -color_rect.size/2
	
