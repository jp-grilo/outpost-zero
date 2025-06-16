# Torre Azul
extends Turrets

func _ready():
	damage = 10
	fire_rate = 1.0
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [40, 60, 90],
		"fire_rate": [30, 40, 60],
		"range": [50, 70, 90]
	}

	upgrade_stats = {
		"damage": [10, 15, 22, 30],
		"fire_rate": [1.0, 0.9, 0.8, 0.7],
		"range": [500, 600, 700, 800]
	}

	super()
