extends Control

var current_base: Node = null

@onready var tower_list_container = $Panel/TowerList

var mode: String = ""  # "base" ou "upgrade"

var available_towers = [
	{
		"name": "Canhão Azul",
		"scene": preload("res://Scenes/turrets/tower_lt_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk1.PNG")
	},
	{
		"name": "Canhão Rosa",
		"scene": preload("res://Scenes/turrets/Turret_1_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk2.PNG")
	},
	{
		"name": "Canhão Desert",
		"scene": preload("res://Scenes/turrets/Turret_2_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk2.PNG")
	},
]

var tower_evolution_tree = {
	"tower_lt_1": ["tower_rt_1", "tower_rt_2"],
	"Turret_1_1": ["Turret_1_2", "Turret_1_3"],
	"Turret_2_1": ["Turret_2_2", "Turret_2_3"]
}

func _ready():
	visible = false
	Economy.connect("coin_updated", Callable(self, "_on_coin_updated"))

func open_tower_selection(base_node):
	current_base = base_node
	mode = "base"
	visible = true
	_render_tower_buttons()

func open_upgrade_selection(tower_instance):
	current_base = tower_instance
	mode = "upgrade"
	visible = true
	_render_upgrade_buttons()

func _render_upgrade_buttons():
	_clear_buttons()

	var current_name = current_base.scene_file_path.get_file().get_basename()
	var evolutions = tower_evolution_tree.get(current_name, [])

	if evolutions.size() == 0:
		_render_sell_only_ui()
		return

	for evolution_name in evolutions:
		var scene_path = "res://Scenes/turrets/%s.tscn" % evolution_name
		var scene = load(scene_path)
		var temp_instance = scene.instantiate()
		var cost = temp_instance.build_cost if "build_cost" in temp_instance else 0
		var can_buy = Economy.can_afford(cost)
		var display_name = temp_instance.custom_name if "custom_name" in temp_instance else evolution_name

		var button = Button.new()
		button.text = "%s - %d Staris" % [display_name, cost]
		button.disabled = not can_buy
		_apply_button_style(button, "upgrade")

		button.pressed.connect(func():
			current_base.upgrade_to(scene)
			visible = false
		)

		tower_list_container.add_child(button)

	var sell_button = Button.new()
	sell_button.text = "💰 Vender Torre (+%d Staris)" % int(current_base.build_cost / 2)
	_apply_button_style(sell_button, "sell")
	sell_button.pressed.connect(func():
		current_base.sell_tower()
		visible = false
	)
	tower_list_container.add_child(sell_button)

	var cancel_button = Button.new()
	cancel_button.text = "❌ Cancelar"
	_apply_button_style(cancel_button, "cancel")
	cancel_button.pressed.connect(func(): visible = false)
	tower_list_container.add_child(cancel_button)

	await get_tree().process_frame
	_adjust_panel_size()

func _render_tower_buttons():
	_clear_buttons()

	for tower_data in available_towers:
		var scene: PackedScene = tower_data["scene"]
		var name = tower_data["name"]
		var temp_instance = scene.instantiate()
		var cost = temp_instance.build_cost if "build_cost" in temp_instance else 0
		var can_buy = Economy.can_afford(cost)

		var button = Button.new()
		button.text = "🛠️ %s - %d Staris" % [name, cost]
		button.disabled = not can_buy
		_apply_button_style(button, "build")

		button.pressed.connect(func():
			if current_base:
				current_base.build_tower(scene)
			visible = false
		)

		tower_list_container.add_child(button)

	if current_base and current_base.has_method("is_built") and current_base.is_built:
		var sell_button = Button.new()
		sell_button.text = "💰 Vender Torre (+%d Staris)" % int(current_base.build_cost / 2)
		_apply_button_style(sell_button, "sell")
		sell_button.pressed.connect(func():
			current_base.sell_tower()
			visible = false
		)
		tower_list_container.add_child(sell_button)

	var cancel_button = Button.new()
	cancel_button.text = "❌ Cancelar"
	_apply_button_style(cancel_button, "cancel")
	cancel_button.pressed.connect(func(): visible = false)
	tower_list_container.add_child(cancel_button)

	await get_tree().process_frame
	_adjust_panel_size()

func _render_sell_only_ui():
	_clear_buttons()

	var sell_button = Button.new()
	sell_button.text = "💰 Vender Torre (+%d Staris)" % int(current_base.build_cost / 2)
	_apply_button_style(sell_button, "sell")
	sell_button.pressed.connect(func():
		current_base.sell_tower()
		visible = false
	)
	tower_list_container.add_child(sell_button)

	var cancel_button = Button.new()
	cancel_button.text = "❌ Cancelar"
	_apply_button_style(cancel_button, "cancel")
	cancel_button.pressed.connect(func(): visible = false)
	tower_list_container.add_child(cancel_button)

	await get_tree().process_frame
	_adjust_panel_size()

func _clear_buttons():
	for child in tower_list_container.get_children():
		tower_list_container.remove_child(child)
		child.queue_free()

func _apply_button_style(button: Button, type: String):
	var theme_color = Color("#00ffcc")
	match type:
		"build":
			theme_color = Color("#caa9ff")
		"upgrade":
			theme_color = Color("#ffaa00")
		"sell":
			theme_color = Color("#ff5555")
		"cancel":
			theme_color = Color("#888888")

	var style = StyleBoxFlat.new()
	style.bg_color = theme_color.darkened(0.2)
	style.border_color = theme_color.lightened(0.5)
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	style.shadow_color = Color(0, 0, 0, 0.6)
	style.shadow_size = 6
	style.anti_aliasing = true

	button.add_theme_stylebox_override("normal", style)

	var hover_style = style.duplicate()
	hover_style.bg_color = theme_color
	button.add_theme_stylebox_override("hover", hover_style)

	var pressed_style = style.duplicate()
	pressed_style.bg_color = theme_color.lightened(0.2)
	button.add_theme_stylebox_override("pressed", pressed_style)

	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color.WHITE)

	# Ajusta altura conforme o tipo
	if type == "sell" or type == "cancel":
		button.custom_minimum_size = Vector2(0, 36)  # menor altura
	else:
		button.custom_minimum_size = Vector2(0, 72)  # altura padrão

func _adjust_panel_size():
	if tower_list_container:
		var total_height = 0
		for child in tower_list_container.get_children():
			total_height += child.size.y + tower_list_container.get_theme_constant("separation")
		$Panel.custom_minimum_size.y = total_height + 40  # padding extra
		$Panel.custom_minimum_size.x = 320  # largura mínima ajustável

func _on_coin_updated(new_amount: int):
	if not visible:
		return

	match mode:
		"base":
			_render_tower_buttons()
		"upgrade":
			_render_upgrade_buttons()
