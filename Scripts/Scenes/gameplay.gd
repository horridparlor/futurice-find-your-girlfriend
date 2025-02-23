extends Gameplay

@onready var enemies_layer : Node2D = $EnemiesLayer;
@onready var player_layer : Node2D = $PlayerLayer;
@onready var instructions_layer : Node2D = $InstructionsLayer;
@onready var instructions : RichTextLabel = $InstructionsLayer/RichTextLabel;

@onready var enemy_spawn_wait_timer : Timer = $Timers/EnemySpawnWait;
@onready var game_over_wait_timer : Timer = $Timers/GameOverWait;
@onready var stream_player : AudioStreamPlayer = $AudioStreamPlayer;
@onready var backframe : ColorRect = $Backframe;
@onready var backdrops_layer : Node2D = $BackdropsLayer;

func on_init() -> void:
	change_music();
	spawn_player();
	spawn_backdrops();

func spawn_backdrops() -> void:
	if is_in_past_level():
		backframe.color = PAST_LEVEL_BACKFRAME_COLOR;
		instructions.text = PAST_LEVEL_INSTRUCTIONS;
	System.Instance.load_child(BACKDROPS_PATH_PREFIX + str(level_index) + BACKDROPS_PATH_SUFFIX, backdrops_layer);

func change_music():
	if level_index == GameplayEnums.LAST_LEVEL:
		stream_player.stream = load(LAST_LEVEL_THEME_PATH);
	elif is_in_past_level():
		stream_player.stream = load(PAST_LEVEL_THEME_PATH);
	stream_player.play();

func spawn_player() -> void:
	player = System.Instance.load_child(PLAYER_PATH, player_layer);
	match level_index:
		GameplayEnums.SLOW_LEVEL:
			player.set_speed(1);
		GameplayEnums.FAST_LEVEL:
			player.set_speed(4);
		GameplayEnums.GHOSTS_SECRET_LEVEL:
			player.set_speed(5);
		GameplayEnums.RAPIDFIRE_LEVEL:
			player.alter_shoot_speed(4);
	player.died.connect(on_player_died);
	

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
		if level_index in GameplayEnums.HUNTED_LEVELS:
			enemy.target_position = player.position;
		enemy.move(delta);

func spawn_enemy() -> void:
	var enemy : Enemy = System.Instance.load_child(ENEMY_PATH, enemies_layer);
	var angle : float = randf() * TAU;
	enemy.position = Vector2(cos(angle), sin(angle)) * System.Window_.y;
	enemy.target_position = -enemy.position;
	if level_index == GameplayEnums.CARS_LEVEL:
		if System.Random.chance(2):
			enemy.target_position.x = enemy.position.x;
		else:
			enemy.target_position.y = enemy.position.y;
	enemy.fix_position();
	if spawns_before_girlfriend > 0:
		spawns_before_girlfriend -= 1;
	else:
		roll_for_enemy_colors(enemy);
	enemy.despawn.connect(on_despawn_enemy);
	enemy.player_hit.connect(on_player_hit);
	enemy.movement_class = System.Random.item(ENEMY_SPEEDS[level_index]);
	if enemy.is_girlfriend():
		enemy.movement_class = 2 if level_index == GameplayEnums.SLOW_LEVEL else min(2, enemy.movement_class);
	enemy.set_is_in_past(is_in_past_level());
	enemy.is_ghost = level_index == GameplayEnums.GHOSTS_SECRET_LEVEL;
	enemy.set_speed();
	match level_index:
		GameplayEnums.GIANT_LEVEL:
			enemy.scale_up(3);
		GameplayEnums.SUPERSONIC_LEVEL:
			if enemy.movement_class == 1:
				enemy.scale_up(System.random.randf_range(1, 2));
		GameplayEnums.GIANTS_SECRET_LEVEL:
			enemy.scale_up(2.5);
	enemies.append(enemy);
	can_spawn_enemy = false;
	enemy_spawn_wait_timer.wait_time = enemy_spawn_wait;
	enemy_spawn_wait_timer.start();

func roll_for_enemy_colors(enemy : Enemy) -> void:
	if becomes_blue(enemy):
		return;
	if (!girlfriend_exists or level_index == GameplayEnums.SLOW_LEVEL) \
	&& System.Random.chance(chance_to_spawn_girlfriend):
		enemy.color = GameplayEnums.EnemyColor.PINK;
		girlfriend_exists = true;

func becomes_blue(enemy : Enemy) -> bool:
	if chance_to_spawn_secret == 0 or !System.Random.chance(chance_to_spawn_secret):
		return false;
	enemy.color = GameplayEnums.EnemyColor.BLUE;
	return true;

func on_despawn_enemy(enemy : Enemy) -> void:
	if enemy.is_girlfriend():
		girlfriend_exists = false;
	enemies.erase(enemy);
	enemy.queue_free();

func on_player_died() -> void:
	on_player_hit();

func on_player_hit(girlfriend_state : GameplayEnums.GirlfriendState = GameplayEnums.GirlfriendState.NO) -> void:
	if game_over:
		return;
	game_over = true;
	match girlfriend_state:
		GameplayEnums.GirlfriendState.YES:
			on_victory();
		GameplayEnums.GirlfriendState.NO:
			on_death();
		GameplayEnums.GirlfriendState.LATE:
			on_secret_level_unlocked();
	game_over_wait_timer.start();

func on_victory():
	did_win = true;
	var victory_screen : Node2D = System.Instance.load_child(
		SECRET_LEVEL_UNLOCK_SCREEN_PATH if is_in_past_level() else VICTORY_SCREEN_PATH, self);
	victory_screen.init(VICTORY_MESSAGES[level_index]);

func on_death():
	System.Instance.load_child(DEATH_SCREEN_PATH, self);

func on_secret_level_unlocked():
	did_unlock_secret_level = true;
	var unlock_screen : Node2D = System.Instance.load_child(SECRET_LEVEL_UNLOCK_SCREEN_PATH, self);
	unlock_screen.init(SECRET_LEVEL_UNLOCK_MESSAGES[secret_to_spawn]);

func check_if_game_started() -> bool:
	return Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W) or \
		Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A) or \
		Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S) or \
		Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D) or \
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_H);

func fade_instructions(delta : float) -> void:
	instructions_layer.modulate.a -= delta / INSTRUCTIONS_FADING_SPEED;
	if instructions_layer.modulate.a <= 0:
		instructions_layer.modulate.a = 0;
		is_fading_instructions = false;

func handle_shooting() -> void:
	if player.is_shooting:
		return;
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_H):
		player.shoot(3 if level_index == GameplayEnums.SUPERMAN_LEVEL else 1);

func _on_enemy_spawn_wait_timeout() -> void:
	enemy_spawn_wait_timer.stop();
	can_spawn_enemy = true;

func _on_game_over_wait_timeout() -> void:
	game_over_wait_timer.stop();
	if did_unlock_secret_level:
		emit_signal("unlocked_secret_level", secret_to_spawn);
		return;
	emit_signal("on_game_over", did_win, level_index);
