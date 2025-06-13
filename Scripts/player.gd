extends Area2D

# ---------------------------------------------------
# PARÂMETROS CONFIGURÁVEIS
# ---------------------------------------------------

@export var speed: float = 300.0
@export var damage: float = 1.0

# ---------------------------------------------------
# VARIÁVEIS INTERNAS
# ---------------------------------------------------

var direction: Vector2 = Vector2.ZERO

# ---------------------------------------------------
# FUNÇÕES DE CICLO DE VIDA
# ---------------------------------------------------

func _ready() -> void:
	# Remove o projétil automaticamente após 5 segundos
	await get_tree().create_timer(5.0).timeout
	if is_inside_tree():
		queue_free()

	# Conecta o sinal de detecção de corpo
	if has_signal("body_entered"):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

# ---------------------------------------------------
# DETECÇÃO DE COLISÃO
# ---------------------------------------------------

func _on_body_entered(body: Node) -> void:
	if not is_instance_valid(body):
		return

	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
