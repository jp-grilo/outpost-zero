# Desert Evolucao - Rapid Dust
extends Turrets
@export var custom_name: String = "Rapid Dust"
func _ready():
	damage = 10
	fire_rate = 0.15
	range = 600
	
	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}
	
	upgrade_costs = {
		"damage": [80, 100, 130],
		"fire_rate": [70, 100, 130],
		"range": [60, 90, 110]
	}

	upgrade_stats = {
		"damage": [10, 12, 14, 16],
		"fire_rate": [0.15, 0.12, 0.10, 0.08],
		"range": [600, 700, 800, 900]
	}

	super()
