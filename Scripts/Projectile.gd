extends Area2D
class_name Projectile

# --- Parâmetros configuráveis ---
@export var speed: float = 300.0
@export var damage: float = 1.0


var direction: Vector2 = Vector2.ZERO

# --- Inicialização ---
func _ready():
	# Garante que o projétil será removido após 5 segundos se não colidir
	await get_tree().create_timer(5.0).timeout
	if is_inside_tree():
		queue_free()

	# Conectando o sinal de detecção dinamicamente (alternativo seguro ao usar instanciamento via código)
	if has_signal("body_entered"):
		connect("body_entered", Callable(self, "_on_body_entered"))

# --- Atualização por frame físico ---
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

# --- Detecção de colisão com inimigo ---
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
