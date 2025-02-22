extends Nexus

@onready var title_layer : GlowNode = $TitleLayer;
@onready var buttons_layer : Node2D = $ButtonsLayer
@onready var audio_stream : AudioStreamPlayer = $AudioStreamPlayer;
@onready var victory_panel : Panel = $VictoryPanel;

func _ready() -> void:
	title_layer.activate_animations();

func init(save_data : SaveData):
	spawn_level_buttons(save_data.levels_unlocked);

func spawn_level_buttons(levels_unlocked_ : int):
	var level_button : LevelButton;
	var current_position : Vector2 = Vector2(-2 * LEVEL_BUTTON_X, 0);
	levels_unlocked = levels_unlocked_;
	if levels_unlocked > GameplayEnums.LAST_LEVEL:
		change_to_victory_nexus();
	for i in range(10):
		level_button = System.Instance.load_child(LEVEL_BUTTON_PATH, buttons_layer);
		level_button.set_level(i);
		level_button.position = current_position;
		current_position.x += LEVEL_BUTTON_X;
		if current_position.x > 2 * LEVEL_BUTTON_X:
			current_position = Vector2(-2 * LEVEL_BUTTON_X, current_position.y + LEVEL_BUTTON_Y);
		if i > levels_unlocked:
			level_button.deactivate();
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
	emit_signal("level_selected", levels_unlocked);
