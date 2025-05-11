extends TextureProgressBar

@export var health_system : HealthSystem

func _ready():
	if health_system:
		health_system.health_changed.connect(update_health_bar)
		update_health_bar(health_system.current_health, health_system.max_health)

func update_health_bar(current: float, max_health: float):
	max_value = max_health
	value = current
