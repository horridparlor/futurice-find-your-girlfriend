extends Gameplay

@onready var enemies_layer : Node2D = $EnemiesLayer;
@onready var player_layer : Node2D = $PlayerLayer;
@onready var instructions_layer : Node2D = $InstructionsLayer;

@onready var enemy_spawn_wait_timer : Timer = $Timers/EnemySpawnWait;
@onready var game_over_wait_timer : Timer = $Timers/GameOverWait;
@onready var stream_player : AudioStreamPlayer = $AudioStreamPlayer;

func _ready() -> void:
	spawn_player();

func change_music():
	if level_index == GameplayEnums.LAST_LEVEL:
		stream_player.stream = load(LAST_LEVEL_THEME_PATH);
		stream_player.play();

func spawn_player() -> void:
	player = System.Instance.load_child(PLAYER_PATH, player_layer);

func _process(delta : float) -> void:
	if game_over:
		return;
	handle_movement(delta);
	handle_shooting();
	if is_fading_instructions:
		fade_instructions(delta);
	if can_spawn_enemy and enemies.size() < max_enemies:
		spawn_enemy();
	move_enemies(delta);

func handle_movement(delta : float) -> void:
	if !game_started:
		if check_if_game_started():
			is_fading_instructions = true;
			game_started = true;
			can_spawn_enemy = true;
		else:
			return;
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		player.move_up(delta);
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		player.move_left(delta);
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		player.move_down(delta);
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		player.move_right(delta);

func move_enemies(delta : float) -> void:
	var enemy : Enemy;
	for e in enemies.duplicate():
		if !System.Instance.exists(e):
			continue;
		enemy = e;
		enemy.move(delta);

func spawn_enemy() -> void:
	var enemy : Enemy = System.Instance.load_child(ENEMY_PATH, enemies_layer);
	var angle : float = randf() * TAU;
	enemy.position = Vector2(cos(angle), sin(angle)) * System.Window_.y;
	enemy.target_position = -enemy.position;
	enemy.fix_position();
	if spawns_before_girlfriend > 0:
		spawns_before_girlfriend -= 1;
	else:
		if !girlfriend_exists && System.Random.chance(chance_to_spawn_girlfriend):
			enemy.color = GameplayEnums.EnemyColor.PINK;
			girlfriend_exists = true;
	enemy.despawn.connect(on_despawn_enemy);
	enemy.player_hit.connect(on_player_hit);
	enemies.append(enemy);
	can_spawn_enemy = false;
	enemy_spawn_wait_timer.wait_time = enemy_spawn_wait;
	enemy_spawn_wait_timer.start();

func on_despawn_enemy(enemy : Enemy) -> void:
	if enemy.is_girlfriend():
		girlfriend_exists = false;
	enemies.erase(enemy);
	enemy.queue_free();

func on_player_hit(is_girlfriend : bool) -> void:
	game_over = true;
	on_victory() if is_girlfriend else on_death();
	game_over_wait_timer.start();

func on_victory():
	did_win = true;
	var victory_screen : Node2D = System.Instance.load_child(VICTORY_SCREEN_PATH, self);
	victory_screen.init(VICTORY_MESSAGES[level_index]);

func on_death():
	System.Instance.load_child(DEATH_SCREEN_PATH, self);

func check_if_game_started() -> bool:
	return Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W) or \
		Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A) or \
		Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S) or \
		Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D) or \
		Input.is_key_pressed(KEY_H);

func fade_instructions(delta : float) -> void:
	instructions_layer.modulate.a -= delta / INSTRUCTIONS_FADING_SPEED;
	if instructions_layer.modulate.a <= 0:
		instructions_layer.modulate.a = 0;
		is_fading_instructions = false;

func handle_shooting() -> void:
	if player.is_shooting:
		return;
	if Input.is_key_pressed(KEY_H):
		player.shoot();

func _on_enemy_spawn_wait_timeout() -> void:
	enemy_spawn_wait_timer.stop();
	can_spawn_enemy = true;

func _on_game_over_wait_timeout() -> void:
	game_over_wait_timer.stop();
	emit_signal("on_game_over", did_win, level_index);
