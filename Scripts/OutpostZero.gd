extends Node2D

@onready var hud = $HUD
@onready var wave_timer = $WaveTimer
@export var spawner_path: NodePath

var current_wave := 0


func _ready():
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	Economy.reset()
	_on_wave_timer_timeout()
	
func _on_wave_timer_timeout():
	current_wave += 1
	print("Wave atual:", current_wave)

	var spawner = get_node_or_null(spawner_path)
	if spawner:
		spawner.start_wave(current_wave)

	hud.update_wave(current_wave)

func start_next_wave():
	current_wave += 1
	print("Wave atual:", current_wave)

	var num_enemies = 3 + current_wave * 2
	var delay = 0.5

	for i in num_enemies:
		await get_tree().create_timer(i * delay).timeout
		get_node(spawner_path).spawn_enemy(current_wave)

func _process(delta: float) -> void:
	if hud:
		# Atualiza o timer da próxima wave
		hud.update_timer($WaveTimer.time_left, $WaveTimer.wait_time)
		hud.update_coin_count(Economy.get_current_coins())
		# Atualiza a contagem de inimigos
		var spawner = get_node_or_null(spawner_path)
		if spawner and spawner.has_method("get_active_enemy_count"):
			var count = spawner.get_active_enemy_count()
			hud.update_enemy_count(count)
