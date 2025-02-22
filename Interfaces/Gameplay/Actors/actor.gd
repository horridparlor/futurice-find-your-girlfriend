extends Node2D
class_name Actor

const SPEED_MULTIPLIER : float = 100;

var movement_class : float = 1;
var speed : int;
var size_class : int;

func set_speed(movemenent_class_ : float = movement_class) -> void:
	movement_class = movemenent_class_;
	speed = SPEED_MULTIPLIER * movement_class;

func fix_position() -> void:
	position = get_fixed_position(position);

func get_fixed_position(vector : Vector2) -> Vector2:
	var margin : int = size_class / 2;
	if vector.x + margin > System.Window_.x / 2:
		vector.x = System.Window_.x / 2 - margin;
	elif vector.x - margin < -System.Window_.x / 2:
		vector.x = -System.Window_.x / 2 + margin;
	if vector.y + margin > System.Window_.y / 2:
		vector.y = System.Window_.y / 2 - margin;
	elif vector.y - margin < -System.Window_.y / 2:
		vector.y = -System.Window_.y / 2 + margin;
	return vector;

func is_colliding_with_obstacle(target_position : Vector2 = position, obstacle_group : String = "Obstacle") -> bool:
	var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state;
	var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new();
	var shape : RectangleShape2D = RectangleShape2D.new();
	shape.size = Vector2(size_class, size_class);

	query.shape = shape
	query.transform = Transform2D(0, target_position);
	query.collide_with_areas = true;
	var result : Array = space_state.intersect_shape(query);
	for r in result:
		if r.collider.is_in_group(obstacle_group):
			return true;
	return false;
