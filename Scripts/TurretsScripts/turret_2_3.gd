# Desert Evolucao - Cannon Dust
extends Turrets
@export var custom_name: String = "Cannon Dust"
func _ready():
	damage = 80
	fire_rate = 2.5
	range = 600

	upgrade_levels = {"damage": 0, "fire_rate": 0, "range": 0}
	
	upgrade_costs = {
		"damage": [100, 140, 180],
		"fire_rate": [70, 90, 110],
		"range": [70, 100, 130]
	}

	upgrade_stats = {
		"damage": [80, 150, 250, 500],
		"fire_rate": [2.5, 2.0, 1.8, 1.5],
		"range": [600, 700, 800, 900]
	}

	super()
