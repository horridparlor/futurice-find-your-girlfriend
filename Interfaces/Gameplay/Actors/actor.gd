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
	var margin : int = size_class / 2;
	if position.x + margin > System.Window_.x / 2:
		position.x = System.Window_.x / 2 - margin;
	elif position.x - margin < -System.Window_.x / 2:
		position.x = -System.Window_.x / 2 + margin;
	if position.y + margin > System.Window_.y / 2:
		position.y = System.Window_.y / 2 - margin;
	elif position.y - margin < -System.Window_.y / 2:
		position.y = -System.Window_.y / 2 + margin;
