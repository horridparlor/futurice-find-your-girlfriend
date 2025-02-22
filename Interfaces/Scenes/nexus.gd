extends Node2D
class_name Nexus

signal level_selected(level_index);

const LEVEL_BUTTON_PATH : String = "res://Prefabs/Nexus/level_button.tscn";
const LEVEL_BUTTON_X : int = 360;
const LEVEL_BUTTON_Y : int = 320;

var levels_unlocked : int;

func init(save_data : SaveData):
	pass;
