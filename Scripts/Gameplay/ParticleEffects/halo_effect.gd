extends HaloEffect

@onready var particles : GPUParticles2D = $GPUParticles2D;

func _ready() -> void:
	particles.process_material.emission_shape_offset.x = 0;
	is_growing = true;
	modulate.a = 1;

func _process(delta: float) -> void:
	if !is_growing:
		return;
	particles.process_material.emission_shape_offset.x += SPEED * delta;
	emit_signal("halo_range", particles.process_material.emission_shape_offset.x);
	if particles.process_material.emission_shape_offset.x >= MAX_SIZE:
		particles.process_material.emission_shape_offset.x = MAX_SIZE;
		is_growing = false;
	modulate.a -= delta / 2;
	if modulate.a <= 0:
		modulate.a = 0;
		is_growing = false;
		emit_signal("halo_range", 0);
