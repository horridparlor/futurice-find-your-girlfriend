extends Actor
class_name Enemy

signal despawn(_self);
signal player_hit(is_girlfriend);

const PINK_COLOR = "fc559b";
const YELLOW_COLOR = "e8e419";
const PINK_SPRITE_PATH : String = "res://Assets/Sprites/Actors/enemyPink.png";

var target_position : Vector2;
var color : GameplayEnums.EnemyColor = GameplayEnums.EnemyColor.YELLOW;
var is_hit : bool;
var is_in_past : bool;
var is_ghost : bool;

func _ready() -> void:
	size_class = -40;
	set_speed();var shape = RectangleShape2D.new()
	shape.size = Vector2(40, 40);

func move(delta : float):
	var move_to : Vector2 = position.move_toward(target_position, speed * delta);
	if is_colliding_with_obstacle(move_to, "EnemyObstacle") and !is_ghost:
		return;
	position = move_to;
	if System.Vectors.equal(position, target_position):
		on_death();
		
func on_death() -> void:
	emit_signal("despawn", self);

func is_girlfriend() -> bool:
	return color == GameplayEnums.EnemyColor.PINK;

func is_late_girlfriend() -> bool:
	return color == GameplayEnums.EnemyColor.BLUE;

func get_girlfriend_state() -> GameplayEnums.GirlfriendState:
	if is_girlfriend():
		return GameplayEnums.GirlfriendState.YES;
	elif is_late_girlfriend():
		return GameplayEnums.GirlfriendState.LATE;
	return GameplayEnums.GirlfriendState.NO;

func scale_up(multiplier : float) -> void:
	pass;

func set_is_in_past(value : bool) -> void:
	is_in_past = value;
	on_is_in_past_set();

func on_is_in_past_set() -> void:
	pass;
