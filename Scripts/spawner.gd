extends Node2D

@export var enemy_scene: PackedScene

@onready var left_spawn = $LeftSpawn
@onready var right_spawn = $RightSpawn
@onready var air_spawn = $AirSpawn
@onready var spawn_timer: Timer = $EnemySpawnTimer

var enemies_to_spawn: int = 0
var current_wave: int = 0
func _ready():
	if not spawn_timer.is_connected("timeout", Callable(self, "_on_EnemySpawnTimer_timeout")):
		spawn_timer.timeout.connect(_on_EnemySpawnTimer_timeout)
	#print("✅ Sinal timeout conectado ao spawner")

func start_wave(wave: int):
	current_wave = wave
	enemies_to_spawn = 3 + wave * 2
	#print(">> Iniciando wave:", wave, " - Inimigos para spawnar:", enemies_to_spawn)
	spawn_timer.start()
	#print("Timer status ao iniciar:", spawn_timer.is_stopped())

func _on_EnemySpawnTimer_timeout():
	#print("Timer disparado. Inimigos restantes:", enemies_to_spawn)

	if enemies_to_spawn <= 0:
		#print("Todos os inimigos da wave foram spawnados.")
		spawn_timer.stop()
		return

	spawn_enemy(current_wave)
	enemies_to_spawn -= 1
	#print("Spawn restante após esse:", enemies_to_spawn)

func spawn_enemy(wave: int):
	if enemy_scene == null:
		push_error("Cena de inimigo não atribuída ao Spawner!")
		return

	var enemy = enemy_scene.instantiate()
	enemy.add_to_group("inimigo")
	
	if enemy == null:
		push_error("Falha ao instanciar inimigo!")
		return

	#print("Spawnando inimigo da wave", wave)

	# Escalonamento
	if "life" in enemy:
		enemy.life += wave * 5
	if "speed" in enemy:
		enemy.speed += wave * 2

	var position: Vector2

	# Direção de spawn por wave
	if wave <= 2:
		#print("→ Spawn pela ESQUERDA")
		position = left_spawn.global_position
	elif wave <= 4:
		var from_left = randf() < 0.5
		position = left_spawn.global_position if from_left else right_spawn.global_position
		#print("→ Spawn aleatório:", "ESQUERDA" if from_left else "DIREITA")
	else:
		var choice = randi() % 3
		match choice:
			0:
				position = left_spawn.global_position
				#print("→ Spawn da ESQUERDA")
			1:
				position = right_spawn.global_position
				#print("→ Spawn da DIREITA")
			2:
				position = air_spawn.global_position
				#print("→ Spawn do AR")

	enemy.global_position = position
	add_child(enemy)
	#print("✅ Inimigo adicionado na posição:", position)


func _on_enemy_spawn_timer_timeout() -> void:
	pass # Replace with function body.

func get_active_enemy_count() -> int:
	return get_tree().get_nodes_in_group("inimigo").size()
