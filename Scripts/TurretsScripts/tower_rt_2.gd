# Azul Evolucao - BigShot
extends Turrets
@export var custom_name: String = "BigShot"
func _ready():
	damage = 50
	fire_rate = 2.5
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}
	
	upgrade_costs = {
		"damage": [70, 110, 150],
		"fire_rate": [50, 70, 90],
		"range": [60, 80, 110]
	}

	upgrade_stats = {
		"damage": [50, 75, 100, 150],
		"fire_rate": [2.5, 2.0, 1.8, 1.5],
		"range": [500, 600, 700, 800]
	}

	super()
