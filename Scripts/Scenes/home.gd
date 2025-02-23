extends Home

@onready var scene_layer : Node2D = $SceneLayer;

func _ready() -> void:
	System.random.randomize();
	System.create_directories();
	DisplayServer.window_set_current_screen(System.Display);
	load_save_data();
	System.Json.write(save_data.to_json(), SAVE_FILE_NAME);
	set_process_input(true);
	open_nexus();

func load_save_data() -> void:
	var data : Dictionary = System.Json.read(SAVE_FILE_NAME);
	save_data = SaveData.from_json(data) if !System.Json.is_error(data) else SaveData.new();

func open_nexus() -> void:
	nexus = System.Instance.load_child(NEXUS_PATH, scene_layer);
	nexus.init(save_data);
	nexus.level_selected.connect(open_level);

func open_level(level_index : int) -> void:
	gameplay = System.Instance.load_child(GAMEPLAY_PATH, scene_layer);
	gameplay.init(level_index);
	gameplay.on_game_over.connect(on_game_over);
	gameplay.unlocked_secret_level.connect(on_secret_level_unlocked);
	save_data.previous_level_selected = level_index;
	if System.Instance.exists(nexus):
		nexus.queue_free();

func on_secret_level_unlocked(level_index : int) -> void:
	save_data.secrets_unlocked[str(level_index)] = true;
	store_save();
	var previous_stage : Gameplay = gameplay;
	open_level(level_index);
	previous_stage.queue_free();

func store_save() -> void:
	System.Json.write(save_data.to_json(), SAVE_FILE_NAME);

func on_game_over(did_win : bool, level_index : int) -> void:
	if did_win:
		if level_index == save_data.levels_unlocked:
			save_data.levels_unlocked += 1;
			store_save();
		save_data.previous_level_selected = save_data.levels_unlocked;
	open_nexus();
	gameplay.queue_free();

func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();
