extends Node2D

const SLIME = preload("res://Scenes/slime.tscn")

func _on_timer_timeout() -> void:
	var enemy = SLIME.instantiate()
	enemy.position = position
	get_parent().add_child(enemy	)
