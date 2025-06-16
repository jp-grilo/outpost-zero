extends Enemy
signal death
var hover_height: float = 120.0  # mais alto que os voadores normais
var vertical_speed: float = 100.0
var spawn_interval: float = 0.5
var death_spawn_amount: int = 50
var voador_scene = preload("res://Scenes/slimeVoador.tscn")

func _ready():
	speed = 20
	coins_reward = 100000
	health_system.max_health = 60000
	add_to_group("boss")
	add_to_group("inimigo_voador")

	var spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	super()

func _move_towards_target(delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * speed

	var desired_y = target.global_position.y - hover_height
	var delta_y = desired_y - global_position.y
	velocity.y = clamp(delta_y, -vertical_speed, vertical_speed)

	animated_sprite.flip_h = direction.x < 0

func _on_spawn_timer_timeout():
	var voador = voador_scene.instantiate()
	voador.global_position = self.global_position + Vector2(randf_range(-10, 10), randf_range(30, 50))
	get_parent().add_child(voador)

func _on_death():
	# Spawn voadores ao morrer
	for i in death_spawn_amount:
		var voador = voador_scene.instantiate()
		voador.global_position = self.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		get_parent().add_child(voador)

	# Emitir sinal para o spawner
	emit_signal("death")

	# Chamar lógica de morte do pai (coins, queue_free, etc)
	super._on_death()
