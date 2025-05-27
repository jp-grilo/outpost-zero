extends Control

var tower_ref: Node = null

@onready var damage_button = $Panel/VBoxContainer/DamageButton
@onready var fire_rate_button = $Panel/VBoxContainer/FireRateButton
@onready var range_button = $Panel/VBoxContainer/RangeButton
@onready var close_button = $Panel/VBoxContainer/CloseButton

func _ready():
	z_index = 1000  # bem alto para garantir
	print("HUD pronta na tela.")
	damage_button.pressed.connect(func(): _upgrade("damage"))
	fire_rate_button.pressed.connect(func(): _upgrade("fire_rate"))
	range_button.pressed.connect(func(): _upgrade("range"))
	close_button.pressed.connect(func(): queue_free())

func set_tower(tower: Node):
	tower_ref = tower
	global_position = tower.global_position + Vector2(50, -50)  # Offset ao lado da torre
	_update_buttons()

func _upgrade(attribute: String):
	if tower_ref:
		tower_ref.try_upgrade_attribute(attribute)
		_update_buttons()

func _update_buttons():
	if not tower_ref:
		return

	damage_button.text = get_upgrade_text("damage")
	fire_rate_button.text = get_upgrade_text("fire_rate")
	range_button.text = get_upgrade_text("range")
	close_button.text = "Fechar"

func get_upgrade_text(attr: String) -> String:
	var lvl = tower_ref.upgrade_levels[attr]
	if lvl >= 3:
		return "%s: MAX" % attr.capitalize()
	var cost = tower_ref.upgrade_costs[attr][lvl]
	return "%s: Nível %d (Custo: %d)" % [attr.capitalize(), lvl, cost]
