# Rosa Evolucao - Heavy Pulse
extends Turrets
@export var custom_name: String = "Heavy Pulse"
func _ready():
	damage = 45
	fire_rate = 2.0
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [70, 110, 150],
		"fire_rate": [50, 70, 90],
		"range": [60, 80, 100]
	}

	upgrade_stats = {
		"damage": [45, 80, 200, 300],
		"fire_rate": [2.0, 1.7, 1.5, 1.3],
		"range": [500, 600, 700, 800]
	}

	super()
