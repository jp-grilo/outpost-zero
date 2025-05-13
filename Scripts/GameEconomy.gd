extends Node

var current_coins: int = 1000 :  # Valor inicial
	set(value):
		current_coins = max(0, value)  # Garante que não fique negativo
		coin_updated.emit(current_coins)  # Emite sinal quando atualiza

signal coin_updated(new_amount)

func add_coins(amount: int) -> void:
	current_coins += amount

func spend_coins(amount: int) -> bool:
	if can_afford(amount):
		current_coins -= amount
		return true
	return false

func can_afford(amount: int) -> bool:
	return current_coins >= amount
