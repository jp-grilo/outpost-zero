# Torre Desert
extends Turrets

func _ready():
	damage = 20
	fire_rate = 0.8
	range = 550

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [90, 130, 160],
		"fire_rate": [70, 90, 110],
		"range": [60, 90, 120]
	}

	upgrade_stats = {
		"damage": [20, 28, 36, 48],
		"fire_rate": [0.8, 0.70, 0.65, 0.55],
		"range": [550, 650, 750, 850]
	}

	super()
