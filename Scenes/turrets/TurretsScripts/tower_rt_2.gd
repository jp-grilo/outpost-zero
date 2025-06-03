extends Turrets
@export var custom_name: String = "Laser Azul"
func _ready():
	damage = 50
	fire_rate = 4.0
	range = 500

	# Níveis iniciais
	upgrade_levels = {
		"damage": 0,
		"fire_rate": 0,
		"range": 0
	}

	# Custos específicos dessa torre
	upgrade_costs = {
		"damage": [80, 100, 150],
		"fire_rate": [80, 90, 100],
		"range": [30, 50, 80]
	}

	# Escalonamento específico dessa torre
	upgrade_stats = {
		"damage": [50, 80, 100, 200],
		"fire_rate": [4.0, 3.6, 3.3, 3.0],
		"range": [500, 600, 700, 800]
	}

	super()
