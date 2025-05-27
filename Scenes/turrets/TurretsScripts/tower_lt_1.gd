extends Turrets

func _ready():
	damage = 10
	fire_rate = 1
	range = 500

	# Níveis iniciais
	upgrade_levels = {
		"damage": 0,
		"fire_rate": 0,
		"range": 0
	}

	# Custos específicos dessa torre
	upgrade_costs = {
		"damage": [50, 80, 120],
		"fire_rate": [20, 25, 30],
		"range": [30, 50, 80]
	}

	# Escalonamento específico dessa torre
	upgrade_stats = {
		"damage": [10, 15, 20, 30],         # começa com 10
		"fire_rate": [1.0, 0.8, 0.6, 0.4],  # menor = mais rápido
		"range": [500, 600, 700, 800]
	}

	super()
