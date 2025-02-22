extends Actor
class_name Enemy

signal despawn(_self);
signal player_hit(is_girlfriend);

const PINK_COLOR = "fc559b";
const YELLOW_COLOR = "e8e419";

var target_position : Vector2;
var color : GameplayEnums.EnemyColor = GameplayEnums.EnemyColor.YELLOW;
var is_hit : bool;

func _ready() -> void:
	size_class = -40;
	set_speed();var shape = RectangleShape2D.new()
	shape.size = Vector2(40, 40);

func move(delta : float):
	var move_to : Vector2 = position.move_toward(target_position, speed * delta);
	if is_colliding_with_obstacle(move_to, "EnemyObstacle"):
		return;
	position = move_to;
	if System.Vectors.equal(position, target_position):
		on_death();
		
func on_death() -> void:
	emit_signal("despawn", self);

func is_girlfriend() -> bool:
	return color == GameplayEnums.EnemyColor.PINK;

func scale_up(multiplier : float) -> void:
	pass;
