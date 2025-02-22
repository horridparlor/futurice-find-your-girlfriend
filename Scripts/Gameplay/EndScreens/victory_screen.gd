extends Node2D

@onready var label : Label = $Label;

func init(message : String):
	label.text = message;
