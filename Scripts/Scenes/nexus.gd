extends Nexus

@onready var title_layer : GlowNode = $TitleLayer;
@onready var buttons_layer : Node2D = $ButtonsLayer
@onready var audio_stream : AudioStreamPlayer = $AudioStreamPlayer;
@onready var victory_panel : Panel = $VictoryPanel;

func _ready() -> void:
	title_layer.activate_animations();

func on_init() -> void:
	spawn_level_buttons(save_data.levels_unlocked);
	spawn_secret_level_buttons(save_data.secrets_unlocked);

func spawn_level_buttons(levels_unlocked_ : int) -> void:
	var level_button : LevelButton;
	var current_position : Vector2 = Vector2(-2 * LEVEL_BUTTON_X, LEVEL_BUTTON_START_Y);
	if save_data.levels_unlocked > GameplayEnums.LAST_LEVEL:
		change_to_victory_nexus();
	for i in range(10):
		level_button = System.Instance.load_child(LEVEL_BUTTON_PATH, buttons_layer);
		level_button.set_level(i);
		level_button.position = current_position;
		current_position.x += LEVEL_BUTTON_X;
		if current_position.x > 2 * LEVEL_BUTTON_X:
			current_position = Vector2(-2 * LEVEL_BUTTON_X, current_position.y + LEVEL_BUTTON_Y);
		if i > save_data.levels_unlocked:
			level_button.deactivate();
		level_button.selected.connect(on_level_selected);

func spawn_secret_level_buttons(secrets_unlocked : Dictionary) -> void:
	var level_button : LevelButton;
	var current_position : Vector2 = Vector2(-1 * SECRET_LEVEL_BUTTON_X, SECRET_LEVEL_BUTTON_Y);
	var secrets : Array = secrets_unlocked.keys();
	secrets.sort();
	for key in secrets:
		if !secrets_unlocked[key]:
			current_position.x += SECRET_LEVEL_BUTTON_X;
			continue;
		level_button = System.Instance.load_child(SECRET_LEVEL_BUTTON_PATH, buttons_layer);
		level_button.position = current_position;
		current_position.x += SECRET_LEVEL_BUTTON_X;
		level_button.set_level(int(key));
		level_button.selected.connect(on_level_selected);

func change_to_victory_nexus() -> void:
	audio_stream.stream = load(VICTORY_THEME_PATH);
	audio_stream.play();
	victory_panel.visible = true;

func on_level_selected(level_index : int):
	emit_signal("level_selected", level_index);

func _process(delta : float) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		enter_last_unlocked_level();

func enter_last_unlocked_level() -> void:
	emit_signal("level_selected", min(save_data.previous_level_selected, GameplayEnums.LAST_LEVEL));
