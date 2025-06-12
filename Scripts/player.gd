extends StaticBody2D

# Referências aos nós filhos
@onready var health_system: HealthSystem = $OutpostZero/HealthSystem  # Sistema de saúde da base
@onready var health_bar: ProgressBar = $OutpostZero/HealthBar         # Barra de vida visual
var show_health_timer: Timer                             # Timer para esconder a barra de vida

func _ready():
	# Configuração inicial da barra de vida
	health_bar.visible = false  # Começa invisível
	health_bar.max_value = health_system.max_health  # Sincroniza com o health system
	health_bar.value = health_system.current_health  # Valor inicial
	
	# Configuração do timer para esconder a barra de vida
	show_health_timer = Timer.new()
	add_child(show_health_timer)
	show_health_timer.timeout.connect(_hide_health_bar)  # Conecta o sinal de timeout
	show_health_timer.wait_time = 2.0  # Tempo de exibição (2 segundos)
	show_health_timer.one_shot = true  # Só executa uma vez
	
	# Conexão dos sinais do health system
	health_system.health_changed.connect(_on_health_changed)  # Quando vida muda
	health_system.died.connect(_on_death)  # Quando vida chega a zero
	
	# Conexão dos sinais da área de detecção
	$Area2D.body_entered.connect(_on_body_entered)  # Quando inimigo entra
	$Area2D.body_exited.connect(_on_body_exited)    # Quando inimigo sai

# Função para receber dano
func take_damage(amount: int):
	health_system.take_damage(amount)  # Aplica o dano
	_show_health_bar_temp()  # Mostra a barra de vida temporariamente

# Chamado quando a vida muda
func _on_health_changed(current: float, max: float):
	health_bar.value = current  # Atualiza a barra visual
	if current < max:  # Só mostra se não estiver com vida cheia
		_show_health_bar_temp()

# Mostra a barra de vida temporariamente
func _show_health_bar_temp():
	health_bar.visible = true
	show_health_timer.start()  # Inicia o timer para esconder depois

# Esconde a barra de vida
func _hide_health_bar():
	health_bar.visible = false

# Chamado quando um corpo entra na área da base
func _on_body_entered(body: Node):
	# Verifica se é um inimigo e tem o método necessário
	if body.is_in_group("enemies") and body.has_method("_on_base_entered"):
		body._on_base_entered(self)  # Notifica o inimigo que entrou na base

# Chamado quando um corpo sai da área da base
func _on_body_exited(body: Node):
	# Verifica se é um inimigo e tem o método necessário
	if body.is_in_group("enemies") and body.has_method("_on_base_exited"):
		body._on_base_exited()  # Notifica o inimigo que saiu da base

# Chamado quando a base é destruída
func _on_death():
	print("Base destruída - Fim de jogo")
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
