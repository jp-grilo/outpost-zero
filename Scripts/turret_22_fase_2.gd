# Torre 1
extends Turrets

func _ready():
	damage = 150
	fire_rate = 2.5
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [200, 250, 300],
		"fire_rate": [100, 150, 200],
		"range": [200, 250, 300]
	}

	upgrade_stats = {
		"damage": [150, 300, 650, 1000],
		"fire_rate": [2.5, 2.0, 1.5, 1.0],
		"range": [500, 600, 700, 800]
	}

	super()
