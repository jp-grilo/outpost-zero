extends Turrets
@export var custom_name: String = "Laser Roxo"
func _ready():
	damage = 150
	fire_rate = 5.0
	range = 500

	# Níveis iniciais
	upgrade_levels = {
		"damage": 0,
		"fire_rate": 0,
		"range": 0
	}

	# Custos específicos dessa torre
	upgrade_costs = {
		"damage": [150, 200, 250],
		"fire_rate": [100, 150, 200],
		"range": [30, 50, 80]
	}

	# Escalonamento específico dessa torre
	upgrade_stats = {
		"damage": [150, 200, 250, 300],
		"fire_rate": [5.0, 4.0, 3.5, 3.0],
		"range": [500, 600, 700, 800]
	}

	super()
