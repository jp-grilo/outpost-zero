extends Turrets
@export var custom_name: String = "Canhão Duplo Roxo"
func _ready():
	damage = 100
	fire_rate = 3.0
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
		"damage": [100, 150, 200, 300],
		"fire_rate": [3.0, 2.8, 2.3, 1.5],
		"range": [500, 600, 700, 800]
	}

	super()
