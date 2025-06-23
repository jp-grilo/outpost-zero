# Torre 1
extends Turrets

func _ready():
	damage = 12
	fire_rate = 0.15
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [90, 150, 250],
		"fire_rate": [100, 200, 300],
		"range": [200, 350, 600]
	}

	upgrade_stats = {
		"damage": [12, 14, 16, 24],
		"fire_rate": [0.15, 0.12, 0.10, 0.08],
		"range": [500, 600, 700, 800]
	}
	
	super()
