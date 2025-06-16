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
	var spawner = get_node_or_null(spawner_path)
	if spawner and spawner.boss_active:
		print("Boss ativo, pausando wave timer.")
		wave_timer.stop()
		spawner.boss_defeated.connect(_on_boss_defeated)
		return

	current_wave += 1
	print("Wave atual:", current_wave)

	if spawner:
		spawner.start_wave(current_wave)

	hud.update_wave(current_wave)

func _on_boss_defeated():
	print("Boss derrotado. Retomando wave timer.")
	wave_timer.start()

func _process(delta: float) -> void:
	if hud:
		hud.update_timer(wave_timer.time_left, wave_timer.wait_time)
		hud.update_coin_count(Economy.get_current_coins())

		var spawner = get_node_or_null(spawner_path)
		if spawner and spawner.has_method("get_active_enemy_count"):
			var count = spawner.get_active_enemy_count()
			hud.update_enemy_count(count)
