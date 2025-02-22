extends Node2D
class_name HaloEffect

signal halo_range(value);

const SPEED : int = 150;
const MAX_SIZE : int = 300;

var is_growing : bool;
var speed : int = SPEED;
var max_size : int = MAX_SIZE;
var fade_speed : float = 2;

func multiply_aura(multiplier : float) -> void:
	speed *= multiplier;
	max_size *= multiplier;

func multiply_shoot_speed(multiplier : float) -> void:
	speed *= multiplier;
	fade_speed *= multiplier;
