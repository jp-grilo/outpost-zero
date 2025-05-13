extends CanvasLayer

@onready var coin_label: Label = $HBoxContainer/CoinLabel

func _ready():
	Economy.coin_updated.connect(update_display)
	update_display(Economy.current_coins)

func update_display(amount: int):
	coin_label.text = str(amount)
