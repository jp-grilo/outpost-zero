# Torre Rosa
extends Turrets

func _ready():
	damage = 14
	fire_rate = 0.9
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [60, 90, 120],
		"fire_rate": [50, 70, 90],
		"range": [50, 80, 100]
	}

	upgrade_stats = {
		"damage": [14, 20, 28, 36],
		"fire_rate": [1.0, 0.85, 0.75, 0.65],
		"range": [500, 600, 700, 800]
	}

	super()
