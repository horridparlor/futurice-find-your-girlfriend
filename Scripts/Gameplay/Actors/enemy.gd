extends Enemy

@onready var color_rect : ColorRect = $ColorRect;
@onready var collision_box : CollisionShape2D = $HitBox/CollisionShape2D;
@onready var unknown_sprite : Sprite2D = $UnknownSprite;
@onready var yellow_sprite : Sprite2D = $YellowSprite;
@onready var pink_sprite : Sprite2D = $PinkSprite;
@onready var blue_sprite : Sprite2D = $BlueSprite;

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Halo"):
		unknown_sprite.visible = false;
		get_revealed_sprite().visible = true;
		if is_hit:
			on_death();	
		is_hit = !is_in_past or is_girlfriend();
	elif area.is_in_group("Player"):
		emit_signal("player_hit", get_girlfriend_state());
	elif area.is_in_group("Monster"):
		on_death();

func on_is_in_past_set() -> void:
	if is_in_past:
		unknown_sprite.texture = load(PINK_SPRITE_PATH);
	
func get_revealed_sprite() -> Sprite2D:
	match color:
		GameplayEnums.EnemyColor.BLUE:
			return blue_sprite;
		GameplayEnums.EnemyColor.PINK:
			if is_in_past:
				return blue_sprite;
			return pink_sprite;
		GameplayEnums.EnemyColor.YELLOW:
			if is_in_past:
				return pink_sprite;
				return pink_sprite;
			return yellow_sprite;
	return yellow_sprite;

func scale_up(multiplier : float) -> void:
	size_class *= multiplier;
	collision_box.shape.size = Vector2(abs(size_class), abs(size_class));
	color_rect.size *= multiplier;
	unknown_sprite.scale *= multiplier;
	yellow_sprite.scale *= multiplier;
	pink_sprite.scale *= multiplier;
	blue_sprite.scale *= multiplier;
	color_rect.position = -color_rect.size/2
	
