extends Node2D
class_name Gameplay

signal on_game_over(did_win, level_index);

const PLAYER_PATH : String = "res://Prefabs/Gameplay/Actors/player.tscn";
const ENEMY_PATH : String = "res://Prefabs/Gameplay/Actors/enemy.tscn";
const INSTRUCTIONS_FADING_SPEED : float = 1.1;
const VICTORY_SCREEN_PATH : String = "res://Prefabs/Gameplay/EndScreens/victory_screen.tscn";
const DEATH_SCREEN_PATH : String = "res://Prefabs/Gameplay/EndScreens/death_screen.tscn";
const LAST_LEVEL_THEME_PATH : String = "res://Assets/Music/TanLines.mp3";

const MAX_ENEMIES_PER_LEVEL : Dictionary = {
	0: 4,
	1: 10,
	2: 20,
	3: 33,
	4: 25,
	5: 42,
	6: 56,
	7: 69,
	8: 47,
	9: 100
};

const ENEMY_SPEEDS : Dictionary = {
	0: [1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
	1: [1, 1, 1, 1, 1, 1, 2, 2, 2, 3],
	2: [2, 2, 2, 2, 2, 2, 2, 2, 2, 3],
	3: [1, 1, 1, 1, 1, 1, 2, 2, 2, 3],
	4: [1, 1, 1, 1, 1, 1, 3, 3, 3, 4],
	5: [1, 2, 2, 2, 2, 3, 3, 3, 3, 3],
	6: [2, 3, 3, 3, 3, 3, 3, 3, 3, 3],
	7: [1, 1, 1, 1, 3, 3, 3, 4, 4, 4],
	8: [1, 5, 5, 5, 5, 5, 5, 5, 5, 5],
	9: [1, 1, 1, 2, 2, 3, 3, 4, 4, 5]
}

const CHANCE_TO_SPAWN_GIRLFRIEND : Dictionary = {
	0: 2,
	1: 4,
	2: 5,
	3: 6,
	4: 7,
	5: 9,
	6: 12,
	7: 14,
	8: 16,
	9: 18
}

const MIN_SPAWNS_BEFORE_GIRLFRIEND : Dictionary = {
	0: 1,
	1: 3,
	2: 5,
	3: 6,
	4: 8,
	5: 10,
	6: 12,
	7: 15,
	8: 18,
	9: 20
}

const ENEMY_SPAWN_WAIT : Dictionary = {
	0: 2,
	1: 1.5,
	2: 1,
	3: 0.8,
	4: 0.6,
	5: 0.5,
	6: 0.4,
	7: 0.3,
	8: 0.2,
	9: 0.1
}

const VICTORY_MESSAGES : Dictionary = {
	0: "SMILES",
	1: "LAUGHS",
	2: "HUGS",
	3: "KISSES",
	4: "SECRETS",
	5: "PROMISES",
	6: "STRESS",
	7: "LOSS",
	8: "DESPAIR",
	9: "MARRIAGE"
}

var player : Player;
var is_fading_instructions : bool;
var game_started : bool;
var max_enemies : int;
var can_spawn_enemy : bool;
var enemies : Array;
var chance_to_spawn_girlfriend : int;
var spawns_before_girlfriend : int;
var girlfriend_exists : bool;
var game_over : bool;
var level_index : int;
var did_win : bool;
var enemy_spawn_wait : float;

func change_music():
	pass;

func init(level_index_ : int) -> void:
	level_index = level_index_
	max_enemies = MAX_ENEMIES_PER_LEVEL[level_index];
	chance_to_spawn_girlfriend = CHANCE_TO_SPAWN_GIRLFRIEND[level_index];
	spawns_before_girlfriend = MIN_SPAWNS_BEFORE_GIRLFRIEND[level_index];
	enemy_spawn_wait = ENEMY_SPAWN_WAIT[level_index];
	change_music();
