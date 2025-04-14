extends Node2D

signal health_changed(new_health)
signal died()

var max_health: int
var current_health: int

func initialize(starting_health: int):
	max_health = starting_health
	current_health = max_health

func update_health(new_health: int):
	current_health = new_health
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		emit_signal("died")
