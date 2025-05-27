extends Node

signal coin_updated(new_amount)

@export var starting_coins: int = 50

var _current_coins: int = starting_coins:
	set(value):
		_current_coins = max(0, value)
		coin_updated.emit(_current_coins)

func get_current_coins() -> int:
	return _current_coins

func add_coins(amount: int) -> void:
	_current_coins += amount

func spend_coins(amount: int) -> bool:
	if can_afford(amount):
		_current_coins -= amount
		return true
	return false

func can_afford(amount: int) -> bool:
	return _current_coins >= amount

func reset(start_amount: int = 50) -> void:
	_current_coins = start_amount
