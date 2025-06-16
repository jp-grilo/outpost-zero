# Azul Evolucao - RapidFire
extends Turrets
@export var custom_name: String = "RapidFire"
func _ready():
	damage = 6
	fire_rate = 0.2
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}
	
	upgrade_costs = {
		"damage": [50, 80, 120],
		"fire_rate": [60, 80, 100],
		"range": [50, 80, 100]
	}

	upgrade_stats = {
		"damage": [6, 8, 10, 12],
		"fire_rate": [0.2, 0.16, 0.13, 0.1],
		"range": [500, 600, 700, 800]
	}

	super()
