extends Node2D
class_name Nexus

signal level_selected(level_index);

const LEVEL_BUTTON_PATH : String = "res://Prefabs/Nexus/level_button.tscn";
const LEVEL_BUTTON_X : int = 360;
const LEVEL_BUTTON_Y : int = 320;
const VICTORY_THEME_PATH : String = "res://Assets/Music/VictoryTheme.mp3";

var save_data : SaveData;

func on_init() -> void:
	pass;

func init(save_data_ : SaveData):
	save_data = save_data_;
	on_init();
