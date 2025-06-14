extends Turrets

func _ready():
	damage = 20
	fire_rate = 1
	range = 500
	var filtered_enemies: Array = ["inimigo_voador"]
	
	# Níveis iniciais
	upgrade_levels = {
		"damage": 0,
		"fire_rate": 0,
		"range": 0
	}

	# Custos específicos dessa torre
	upgrade_costs = {
		"damage": [60, 80, 90],
		"fire_rate": [25, 30, 40],
		"range": [40, 60, 90]
	}

	upgrade_stats = {
		"damage": [20, 30, 40, 50],
		"fire_rate": [1.0, 0.85, 0.65, 0.5],
		"range": [500, 600, 700, 800]
	}

	super()
