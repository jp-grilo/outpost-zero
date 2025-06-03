extends Turrets
@export var custom_name: String = "Misseis Gigantes Desert"
func _ready():
	damage = 500
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
		"damage": [500, 600, 700],
		"fire_rate": [400, 500, 600],
		"range": [30, 50, 80]
	}

	# Escalonamento específico dessa torre
	upgrade_stats = {
		"damage": [500, 800, 1000, 2000],         # começa com 10
		"fire_rate": [4.0, 3.5, 3.0, 2.5],  # menor = mais rápido
		"range": [500, 600, 700, 800]
	}

	super()
