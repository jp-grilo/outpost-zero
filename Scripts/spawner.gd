extends Node2D

@export var enemy_scene: PackedScene
@export var flying_enemy_scene: PackedScene

@onready var left_spawn = $LeftSpawn
@onready var right_spawn = $RightSpawn
@onready var air_spawn = $AirSpawn
@onready var spawn_timer: Timer = $EnemySpawnTimer

var enemies_to_spawn: int = 0
var current_wave: int = 0

func _ready():
	if not spawn_timer.is_connected("timeout", Callable(self, "_on_EnemySpawnTimer_timeout")):
		spawn_timer.timeout.connect(_on_EnemySpawnTimer_timeout)

func start_wave(wave: int):
	current_wave = wave
	enemies_to_spawn = 3 + wave * 2
	spawn_timer.start()

func _on_EnemySpawnTimer_timeout():
	if enemies_to_spawn <= 0:
		spawn_timer.stop()
		return

	spawn_enemy(current_wave)
	enemies_to_spawn -= 1

func spawn_enemy(wave: int):
	var enemy: Node2D
	var position: Vector2

	# Direção de spawn por wave
	if wave <= 2:
		position = left_spawn.global_position
		enemy = enemy_scene.instantiate()
	elif wave <= 4:
		var from_left = randf() < 0.5
		position = left_spawn.global_position if from_left else right_spawn.global_position
		enemy = enemy_scene.instantiate()
	else:
		var choice = randi() % 3
		match choice:
			0:
				position = left_spawn.global_position
				enemy = enemy_scene.instantiate()
			1:
				position = right_spawn.global_position
				enemy = enemy_scene.instantiate()
			2:
				position = air_spawn.global_position
				enemy = flying_enemy_scene.instantiate()  # <- aqui usamos o slime voador

	# Falha ao instanciar
	if enemy == null:
		push_error("Falha ao instanciar inimigo!")
		return

	# Adiciona grupo correspondente
	if position == air_spawn.global_position:
		enemy.add_to_group("inimigo_voador")
	else:
		enemy.add_to_group("inimigo")

	# Escalonamento de atributos
	if "life" in enemy:
		enemy.life += wave * 5
	if "speed" in enemy:
		enemy.speed += wave * 2

	# Posiciona e adiciona à cena
	enemy.global_position = position
	add_child(enemy)

func get_active_enemy_count() -> int:
	return get_tree().get_nodes_in_group("inimigo").size() + get_tree().get_nodes_in_group("inimigo_voador").size()
