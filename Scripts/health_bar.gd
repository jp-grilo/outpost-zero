extends ProgressBar

@onready var health_system = get_parent().get_node("HealthSystem")

func _ready():
	# Configura os valores iniciais
	max_value = health_system.max_health
	value = health_system.current_health
	
	# Conecta o sinal de vida alterada
	health_system.health_changed.connect(_on_health_changed)
	
	# Posiciona a barra acima do inimigo
	position = Vector2(-size.x / 2, -20)  # Ajuste Y conforme necessário

func _on_health_changed(current, _max):
	value = current  # Atualiza o valor da ProgressBar
