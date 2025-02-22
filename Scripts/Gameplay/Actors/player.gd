extends Player

@onready var shoot_cooldown : Timer = $ShootCooldown;
@onready var halo_collision : CollisionShape2D = $HaloArea/Collision;

func on_shoot() -> void:
	halo_effect = System.Instance.load_child(HALO_EFFECT_PATH, self);
	halo_effect.halo_range.connect(on_halo_range);
	shoot_cooldown.start();

func on_halo_range(value : float) -> void:
	halo_collision.shape.radius = value;

func _on_shoot_cooldown_timeout() -> void:
	shoot_cooldown.stop();
	halo_effect.queue_free();
	is_shooting = false;
	halo_collision.shape.radius = 0;
