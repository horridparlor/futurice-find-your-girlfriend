extends Player

@onready var shoot_cooldown : Timer = $ShootCooldown;
@onready var halo_collision : CollisionShape2D = $HaloArea/Collision;

func on_shoot(multiplier : float) -> void:
	halo_effect = System.Instance.load_child(HALO_EFFECT_PATH, self);
	halo_effect.halo_range.connect(on_halo_range);
	halo_effect.multiply_aura(multiplier);
	halo_effect.multiply_shoot_speed(shoot_speed);
	shoot_cooldown.start();

func alter_shoot_speed(multiplier : float) -> void:
	shoot_speed *= multiplier;
	shoot_cooldown.wait_time /= multiplier;
	
func on_halo_range(value : float) -> void:
	halo_collision.shape.radius = value;

func _on_shoot_cooldown_timeout() -> void:
	shoot_cooldown.stop();
	halo_effect.queue_free();
	is_shooting = false;
	halo_collision.shape.radius = 0;


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Monster"):
		on_death();
