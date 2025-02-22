extends Home

func _ready() -> void:
	System.random.randomize();
	System.create_directories();
	load_save_data();
	System.Json.write(save_data.to_json(), SAVE_FILE_NAME);
	set_process_input(true);
	open_nexus();

func load_save_data() -> void:
	var data : Dictionary = System.Json.read(SAVE_FILE_NAME);
	save_data = SaveData.from_json(data) if !System.Json.is_error(data) else SaveData.new();

func open_nexus() -> void:
	nexus = System.Instance.load_child(NEXUS_PATH, self);
	nexus.init(save_data);
	nexus.level_selected.connect(open_level);

func open_level(level_index : int) -> void:
	gameplay = System.Instance.load_child(GAMEPLAY_PATH, self);
	gameplay.init(level_index);
	gameplay.on_game_over.connect(on_game_over);
	nexus.queue_free();

func on_game_over(did_win : bool, level_index : int) -> void:
	if did_win && level_index == save_data.levels_unlocked && level_index < GameplayEnums.LAST_LEVEL:
		save_data.levels_unlocked += 1;
		System.Json.write(save_data.to_json(), SAVE_FILE_NAME);
	open_nexus();
	gameplay.queue_free();

func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();
