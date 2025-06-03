extends Turrets
@export var custom_name: String = "Canhão Duplo Azul"
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
		"damage": [40, 60, 80],
		"fire_rate": [20, 25, 30],
		"range": [30, 50, 80]
	}

	upgrade_stats = {
		"damage": [10, 15, 20, 30],
		"fire_rate": [1.0, 0.8, 0.6, 0.4],
		"range": [500, 600, 700, 800]
	}

	super()
