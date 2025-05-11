extends StaticBody2D

@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
var show_health_timer: Timer

func _ready():
	# Configuração idêntica à dos inimigos
	health_bar.visible = false
	health_bar.max_value = health_system.max_health
	health_bar.value = health_system.current_health
	
	# Timer com mesmos parâmetros dos inimigos
	show_health_timer = Timer.new()
	add_child(show_health_timer)
	show_health_timer.timeout.connect(_hide_health_bar)
	show_health_timer.wait_time = 2.0  # 2 segundos como nos inimigos
	show_health_timer.one_shot = true
	
	health_system.health_changed.connect(_on_health_changed)
	health_system.died.connect(_on_death)

func take_damage(amount: int):
	health_system.take_damage(amount)
	_show_health_bar_temp()  # Mesma função dos inimigos

func _on_health_changed(current: float, max: float):
	health_bar.value = current
	if current < max:  # Só mostra se não estiver com vida cheia
		_show_health_bar_temp()

func _show_health_bar_temp():
	health_bar.visible = true
	show_health_timer.start()  # Usa o tempo configurado (2s)

func _hide_health_bar():
	health_bar.visible = false

func _on_death():
	print("Base destruída - Fim de jogo")
	get_tree().reload_current_scene()  # Ou sua lógica de game over
