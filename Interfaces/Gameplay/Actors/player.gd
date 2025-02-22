extends Actor
class_name Player

const HALO_EFFECT_PATH : String = "res://Prefabs/Gameplay/ParticleEffects/halo_effect.tscn";

var is_shooting;
var halo_effect : HaloEffect;

func _ready() -> void:
	movement_class = 3;
	set_speed();
	size = 40;

func shoot() -> void:
	is_shooting = true;
	on_shoot();

func on_shoot() -> void:
	pass;

func move_up(delta : float) -> void:
	position.y -= speed * delta;
	fix_position();

func move_left(delta : float) -> void:
	position.x -= speed * delta;
	fix_position();

func move_down(delta : float) -> void:
	position.y += speed * delta;
	fix_position();
	
func move_right(delta : float) -> void:
	position.x += speed * delta;
	fix_position();
