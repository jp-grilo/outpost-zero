extends Node
class_name HealthSystem

signal health_changed(current_health, max_health)
signal died()

@export var max_health := 10.0  # Valor padrão que pode ser sobrescrito no inspector
var current_health : float = max_health

func _ready():
	current_health = max_health  # Inicializa com o valor definido no nó

func take_damage(amount: float) -> void:
	set_health(current_health - amount)

func heal(amount: float) -> void:
	set_health(current_health + amount)

func reset() -> void:
	set_health(max_health)

func set_health(value: float) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		died.emit()
