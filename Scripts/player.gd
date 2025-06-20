extends StaticBody2D
class_name Base

# ---------------------------------------------------
# REFERÊNCIAS A NÓS EXTERNOS (via caminho absoluto)
# ---------------------------------------------------

@onready var health_system: HealthSystem = get_node_or_null("/root/OutpostZero/player/OutpostZero/HealthSystem")
@onready var health_bar: ProgressBar = get_node_or_null("/root/OutpostZero/HUD/Control/MarginContainer/VBoxContainer/HealthBar")

# ---------------------------------------------------
# VARIÁVEIS INTERNAS
# ---------------------------------------------------

var show_health_timer: Timer

# ---------------------------------------------------
# FUNÇÕES DE CICLO DE VIDA
# ---------------------------------------------------

func _ready():
	# Inicializa valores de vida e conecta sinais se os nós forem encontrados
	if health_bar and health_system:
		health_bar.max_value = health_system.max_health
		health_bar.value = health_system.current_health

		health_system.health_changed.connect(_on_health_changed)
		health_system.died.connect(_on_death)

		$Area2D.body_entered.connect(_on_body_entered)
		$Area2D.body_exited.connect(_on_body_exited)
	else:
		push_error("❌ HealthBar ou HealthSystem não encontrados.")

	# Necessário para que as torres identifiquem a base como 'player'
	add_to_group("player")

# ---------------------------------------------------
# FUNÇÕES DE COMBATE E DANO
# ---------------------------------------------------

func take_damage(amount: int):
	health_system.take_damage(amount)
	_show_health_bar_temp()

func _on_health_changed(current: float, max: float):
	health_bar.value = current
	if current < max:
		_show_health_bar_temp()

func _show_health_bar_temp():
	health_bar.visible = true

# ---------------------------------------------------
# DETECÇÃO DE INIMIGOS NA ÁREA DA BASE
# ---------------------------------------------------

func _on_body_entered(body: Node):
	if body.is_in_group("enemies") and body.has_method("_on_base_entered"):
		body._on_base_entered(self)

func _on_body_exited(body: Node):
	if body.is_in_group("enemies") and body.has_method("_on_base_exited"):
		body._on_base_exited()

# ---------------------------------------------------
# GAME OVER
# ---------------------------------------------------

func _on_death():
	print("Base destruída - Fim de jogo")
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
