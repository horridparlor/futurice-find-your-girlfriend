extends HaloEffect

@onready var particles : GPUParticles2D = $GPUParticles2D;

func _ready() -> void:
	particles.process_material.emission_shape_offset.x = 0;
	is_growing = true;
	modulate.a = 1;

func _process(delta: float) -> void:
	if !is_growing:
		return;
	particles.process_material.emission_shape_offset.x += speed * delta;
	emit_signal("halo_range", particles.process_material.emission_shape_offset.x);
	if particles.process_material.emission_shape_offset.x >= max_size:
		particles.process_material.emission_shape_offset.x = max_size;
		is_growing = false;
	modulate.a -= delta / fade_speed;
	if modulate.a <= 0:
		modulate.a = 0;
		is_growing = false;
		emit_signal("halo_range", 0);
