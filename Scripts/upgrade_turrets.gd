extends Control

var tower_ref: Node = null

@onready var damage_button = $Panel/VBoxContainer/DamageButton
@onready var fire_rate_button = $Panel/VBoxContainer/FireRateButton
@onready var range_button = $Panel/VBoxContainer/RangeButton
@onready var close_button = $Panel/VBoxContainer/CloseButton
@onready var targeting_button = $Panel/VBoxContainer/TargetingModeButton
var targeting_modes = ["inimigo_terrestre", "inimigo_voador", "inimigo_tank"]
var current_target_index = 0

func _ready():
	z_index = 1000  # bem alto para garantir visibilidade
	print("HUD pronta na tela.")
	
	# Aplica estilo aos botões
	_apply_button_style(damage_button, "damage")
	_apply_button_style(fire_rate_button, "fire_rate")
	_apply_button_style(range_button, "range")
	_apply_button_style(targeting_button, "targeting")
	_apply_button_style(close_button, "close")
	
	damage_button.pressed.connect(func(): _upgrade("damage"))
	fire_rate_button.pressed.connect(func(): _upgrade("fire_rate"))
	range_button.pressed.connect(func(): _upgrade("range"))
	targeting_button.pressed.connect(_on_targeting_mode_pressed)
	close_button.pressed.connect(func(): queue_free())

func set_tower(tower: Node):
	tower_ref = tower
	global_position = tower.global_position + Vector2(50, -50)  # Offset ao lado da torre
	_update_buttons()
	
func _on_targeting_mode_pressed():
	if not tower_ref:
		return

	current_target_index = (current_target_index + 1) % targeting_modes.size()
	tower_ref.targeting_mode = targeting_modes[current_target_index]
	_update_targeting_button()

func _update_targeting_button():
	if not tower_ref:
		return
	var label := ""
	match tower_ref.targeting_mode:
		"inimigo_terrestre":
			label = "Terrestre"
		"inimigo_voador":
			label = "Voador"
		"inimigo_tank":
			label = "Tank"
		_:
			label = "Desconhecido"
	targeting_button.text = "Modo: %s" % label

	# Atualiza o índice atual para manter sincronizado
	current_target_index = targeting_modes.find(tower_ref.targeting_mode)
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
	_update_targeting_button()
	
func get_upgrade_text(attr: String) -> String:
	var lvl = tower_ref.upgrade_levels[attr]
	var value_now = tower_ref.upgrade_stats[attr][lvl]
	
	var label = ""
	match attr:
		"damage":
			label = "Dano"
		"fire_rate":
			label = "V. Disp."
		"range":
			label = "Alcance"
		_:
			label = attr.capitalize()
	
	if lvl >= 3:
		return "%s: %.1f (MAX)" % [label, value_now]
	
	var next_value = tower_ref.upgrade_stats[attr][lvl + 1]
	var cost = tower_ref.upgrade_costs[attr][lvl]
	return "%s: %.1f ➔ %.1f (%d Staris)" % [label, value_now, next_value, cost]

func _apply_button_style(button: Button, type: String):
	var theme_color = Color("#00ffcc")  # cor base padrão
	match type:
		"damage":
			theme_color = Color("#ff5555")
		"fire_rate":
			theme_color = Color("#ffaa00")
		"range":
			theme_color = Color("#55aaff")
		"targeting":
			theme_color = Color("#bb88ff")  # lilás ou outra cor pro botão de modo
		"close":
			theme_color = Color("#888888")
	
	var style = StyleBoxFlat.new()
	style.bg_color = theme_color.darkened(0.2)
	style.border_color = theme_color.lightened(0.5)
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	style.shadow_color = Color(0, 0, 0, 0.6)
	style.shadow_size = 8
	style.anti_aliasing = true

	button.add_theme_stylebox_override("normal", style)

	var hover_style = style.duplicate()
	hover_style.bg_color = theme_color
	button.add_theme_stylebox_override("hover", hover_style)

	var pressed_style = style.duplicate()
	pressed_style.bg_color = theme_color.lightened(0.2)
	button.add_theme_stylebox_override("pressed", pressed_style)

	button.add_theme_font_size_override("font_size", 20)
