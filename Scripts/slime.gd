extends CharacterBody2D
 
# Referências aos nós
@onready var target = get_tree().get_root().get_node("OutpostZero/player")  # Alvo (player)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Sprite animado
@onready var health_system: HealthSystem = $HealthSystem  # Sistema de saúde
@onready var health_bar: ProgressBar = $HealthBar  # Barra de vida

# Variáveis de controle
var base_damage_timer: Timer  # Timer para dano na base
var is_in_base: bool = false  # Flag se está na base
var base_ref: StaticBody2D = null  # Referência à base atual

# Configurações de movimento
var speed: float = 50.0  # Velocidade de movimento
var gravity: float = 500.0  # Força da gravidade

# Timer para barra de vida
var show_health_timer: Timer

func _ready():
	# Configuração inicial da barra de vida
	health_bar.visible = false  # Começa invisível
	
	# Timer para esconder a barra de vida
	show_health_timer = Timer.new()
	add_child(show_health_timer)
	show_health_timer.timeout.connect(_hide_health_bar)
	show_health_timer.one_shot = true
	
	# Timer para dano na base
	base_damage_timer = Timer.new()
	add_child(base_damage_timer)
	base_damage_timer.timeout.connect(_deal_base_damage)
	base_damage_timer.wait_time = 2.0  # Dano a cada 2 segundos
	base_damage_timer.one_shot = false  # Repetitivo
	
	# Conexão dos sinais do health system
	health_system.health_changed.connect(_on_health_changed)
	health_system.died.connect(_on_death)
	
	# Configura valores iniciais da barra
	health_bar.max_value = health_system.max_health
	health_bar.value = health_system.current_health

# Processamento físico (movimento)
func _physics_process(delta: float) -> void:
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Para no chão

	# Movimento em direção ao alvo
	if target != null and target.is_inside_tree():
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed  # Movimento horizontal
		animated_sprite.flip_h = direction.x < 0  # Vira o sprite conforme direção
	else:
		velocity.x = 0  # Para se não tiver alvo

	move_and_slide()  # Aplica o movimento

# Chamado quando entra na base
func _on_base_entered(base: StaticBody2D):
	is_in_base = true  # Ativa flag
	base_ref = base  # Armazena referência
	base_damage_timer.start()  # Inicia o timer de dano

# Chamado quando sai da base
func _on_base_exited():
	is_in_base = false  # Desativa flag
	base_ref = null  # Limpa referência
	base_damage_timer.stop()  # Para o timer de dano

# Aplica dano à base
func _deal_base_damage():
	if is_in_base and base_ref and base_ref.has_method("take_damage"):
		base_ref.take_damage(1)  # Aplica 1 de dano

# Chamado quando colide com uma flecha
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("arrow"):
		body.queue_free()  # Remove a flecha
		health_system.take_damage(1)  # Toma 1 de dano
		health_bar.visible = true  # Mostra barra de vida
		show_health_timer.start(2.0)  # Temporizador para esconder

# Chamado quando a vida muda
func _on_health_changed(current_health: float, max_health: float):
	health_bar.value = current_health  # Atualiza barra visual
	if current_health < max_health:  # Se não estiver com vida cheia
		health_bar.visible = true  # Mostra barra
		show_health_timer.start(2.0)  # Temporizador para esconder

# Esconde a barra de vida
func _hide_health_bar():
	health_bar.visible = false

# Adicione junto com os outros métodos do inimigo
func take_damage(amount: int):
	health_system.take_damage(amount)
	# Mostra a barra de vida ao receber dano
	health_bar.visible = true
	show_health_timer.start(2.0)  # Mostra por 2 segundos

# Chamado quando o inimigo morre
func _on_death():
	remove_from_group("inimigo")  # Remove do grupo
	Economy.add_coins(10)
	queue_free()  # Destroi o inimigo
