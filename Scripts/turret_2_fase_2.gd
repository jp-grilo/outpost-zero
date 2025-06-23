# Torre 1
extends Turrets
@export var custom_name: String = "Ultra Star Fire"
func _ready():
	damage = 6
	fire_rate = 0.3
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [50, 70, 90],
		"fire_rate": [50, 80, 100],
		"range": [100, 200, 500]
	}

	upgrade_stats = {
		"damage": [6, 8, 10, 12],
		"fire_rate": [0.3, 0.25, 0.2, 0.15],
		"range": [500, 600, 700, 800]
	}
	
	super()
