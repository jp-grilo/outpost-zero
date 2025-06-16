extends Node2D

signal boss_defeated

@export var enemy_definitions: Array[Dictionary] = [
	{
		"type": "ground",
		"scene": preload("res://Scenes/slime.tscn")
	},
	{
		"type": "ground",
		"scene": preload("res://Scenes/Brutamontes.tscn")
	},
	{
		"type": "air",
		"scene": preload("res://Scenes/slimeVoador.tscn")
	}
]

@onready var left_spawn = $LeftSpawn
@onready var right_spawn = $RightSpawn
@onready var air_spawn = $AirSpawn
@onready var air_spawn2 = $AirSpawn2
@onready var boss_spawner = $BossSpawn
@onready var spawn_timer: Timer = $EnemySpawnTimer

var enemies_to_spawn: int = 0
var current_wave: int = 0
var boss_active: bool = false

func _ready():
	if not spawn_timer.is_connected("timeout", Callable(self, "_on_EnemySpawnTimer_timeout")):
		spawn_timer.timeout.connect(_on_EnemySpawnTimer_timeout)

func start_wave(wave: int):
	if boss_active:
		print("Wave bloqueada: boss ainda está ativo!")
		return

	current_wave = wave

	if wave == 20:
		enemies_to_spawn = 0
		spawn_boss()
	else:
		enemies_to_spawn = int(5 + wave * 2 + pow(wave, 1.2))
		spawn_timer.wait_time = max(0.3, 1.0 - (wave * 0.03))
		spawn_timer.start()

func _on_EnemySpawnTimer_timeout():
	if enemies_to_spawn <= 0:
		spawn_timer.stop()
		return

	var spawn_count = min(2 + int(current_wave / 3), enemies_to_spawn)
	call_deferred("_spawn_batch", spawn_count)

func _spawn_batch(count: int) -> void:
	for i in count:
		if enemies_to_spawn <= 0:
			return
		spawn_enemy(current_wave)
		enemies_to_spawn -= 1
		await get_tree().create_timer(0.1).timeout

func spawn_enemy(wave: int):
	if enemy_definitions.is_empty():
		push_error("Nenhuma definição de inimigo encontrada!")
		return

	var valid_definitions = []
	for def in enemy_definitions:
		var scene = def.get("scene", null)
		if scene == null:
			continue
		var path = scene.resource_path

		if path == "res://Scenes/Brutamontes.tscn":
			if wave < 11:
				continue
			if randf() < 0.8:
				continue

		valid_definitions.append(def)

	if valid_definitions.is_empty():
		push_error("Nenhuma definição válida de inimigo para essa wave!")
		return

	var definition = valid_definitions[randi() % valid_definitions.size()]
	var enemy_scene = definition.get("scene", null)
	var type = definition.get("type", "")

	if enemy_scene == null or type == "":
		push_error("Definição de inimigo inválida!")
		return

	var enemy = enemy_scene.instantiate()
	var position: Vector2

	match type:
		"ground":
			if wave <= 2:
				position = left_spawn.global_position
			elif wave <= 4:
				position = [left_spawn.global_position, right_spawn.global_position].pick_random()
			else:
				position = [left_spawn.global_position, right_spawn.global_position].pick_random()
		"air":
			if wave <= 4:
				queue_free_safe(enemy)
				return
			elif wave <= 6:
				position = air_spawn.global_position
			else:
				position = [air_spawn.global_position, air_spawn2.global_position].pick_random()
		_:
			push_error("Tipo de inimigo desconhecido: %s" % type)
			return

	if enemy == null:
		push_error("Falha ao instanciar inimigo!")
		return

	if enemy.has_node("HealthSystem"):
		var health_system = enemy.get_node("HealthSystem")
		health_system.max_health *= 1.0 + (wave * 0.25)

	if "speed" in enemy:
		enemy.speed *= 1.0 + (wave * 0.04)

	enemy.global_position = position
	add_child(enemy)

func queue_free_safe(enemy):
	if is_instance_valid(enemy):
		enemy.queue_free()

func get_active_enemy_count() -> int:
	var total := 0
	for enemy in get_tree().get_nodes_in_group("inimigo_terrestre"):
		if is_instance_valid(enemy): total += 1
	for enemy in get_tree().get_nodes_in_group("inimigo_aereo"):
		if is_instance_valid(enemy): total += 1
	for enemy in get_tree().get_nodes_in_group("inimigo_tank"):
		if is_instance_valid(enemy): total += 1
	return total

func spawn_boss():
	var boss_scene = preload("res://Scenes/BossEstrela.tscn")
	var boss = boss_scene.instantiate()
	boss.global_position = boss_spawner.global_position
	add_child(boss)

	boss_active = true
	if boss.has_signal("death"):
		boss.connect("death", Callable(self, "_on_boss_defeated"))
	else:
		boss.connect("tree_exited", Callable(self, "_on_boss_defeated"))

func _on_boss_defeated():
	boss_active = false
	emit_signal("boss_defeated")
