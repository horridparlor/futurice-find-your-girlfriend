extends Actor
class_name Enemy

signal despawn(_self);
signal player_hit(is_girlfriend);

const PINK_COLOR = "fc559b";
const YELLOW_COLOR = "e8e419";

var target_position : Vector2;
var color : GameplayEnums.EnemyColor = GameplayEnums.EnemyColor.YELLOW;

func _ready() -> void:
	size = -40;
	set_speed();

func move(delta : float):
	position = position.move_toward(target_position, speed * delta);
	if System.Vectors.equal(position, target_position):
		emit_signal("despawn", self);

func is_girlfriend() -> bool:
	return color == GameplayEnums.EnemyColor.PINK;
