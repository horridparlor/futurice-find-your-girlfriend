extends Actor
class_name Player

signal died;

const HALO_EFFECT_PATH : String = "res://Prefabs/Gameplay/ParticleEffects/halo_effect.tscn";

var is_shooting;
var halo_effect : HaloEffect;
var shoot_speed : float = 1;

func _ready() -> void:
	movement_class = 3;
	set_speed();
	size_class = 40;

func alter_shoot_speed(multiplier : float) -> void:
	pass;

func on_death() -> void:
	emit_signal("died");

func shoot(multiplier : float) -> void:
	is_shooting = true;
	on_shoot(multiplier);

func on_shoot(multiplier : float) -> void:
	pass;

func move_up(delta : float) -> void:
	move_to(Vector2(position.x, position.y - speed * delta));

func move_left(delta : float) -> void:
	move_to(Vector2(position.x - speed * delta, position.y));

func move_down(delta : float) -> void:
	move_to(Vector2(position.x, position.y + speed * delta));
	
func move_right(delta : float) -> void:
	move_to(Vector2(position.x + speed * delta, position.y));

func move_to(target_position : Vector2) -> void:
	target_position = get_fixed_position(target_position);
	if is_colliding_with_obstacle(target_position):
		return;
	position = target_position;
