# Torre 1
extends Turrets
@export var custom_name: String = "Blaster Pink"
func _ready():
	damage = 50
	fire_rate = 3.0
	range = 500

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}

	upgrade_costs = {
		"damage": [50, 100, 150],
		"fire_rate": [50, 75, 100],
		"range": [100, 150, 250]
	}

	upgrade_stats = {
		"damage": [50, 100, 200, 300],
		"fire_rate": [3.0, 2.5, 2.0, 1.5],
		"range": [500, 600, 700, 800]
	}
	
	super()
