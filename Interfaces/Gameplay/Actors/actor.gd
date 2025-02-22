extends Node2D
class_name Actor

const SPEED_MULTIPLIER : float = 100;

var movement_class : int = 1;
var speed : int;
var size : int;

func set_speed() -> void:
	speed = SPEED_MULTIPLIER * movement_class;

func fix_position() -> void:
	var margin : int = size / 2;
	if position.x + margin > System.Window_.x / 2:
		position.x = System.Window_.x / 2 - margin;
	elif position.x - margin < -System.Window_.x / 2:
		position.x = -System.Window_.x / 2 + margin;
	if position.y + margin > System.Window_.y / 2:
		position.y = System.Window_.y / 2 - margin;
	elif position.y - margin < -System.Window_.y / 2:
		position.y = -System.Window_.y / 2 + margin;
