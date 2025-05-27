extends Control

var current_base: Node = null

@onready var tower_list_container = $Panel/TowerList

var mode: String = ""  # "base" ou "upgrade"

# Lista inicial de torres para construção
var available_towers = [
	{
		"name": "Metralhadora",
		"scene": preload("res://Scenes/turrets/tower_lt_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk1.PNG")
	},
	{
		"name": "Metralhadora-2",
		"scene": preload("res://Scenes/turrets/Turret_1_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk2.PNG")
	},
]

# Mapeamento de evoluções de torres (árvore de upgrade)
var tower_evolution_tree = {
	"tower_lt_1": ["tower_rt_1"],
	"Turret_1_1": ["Turret_1_2", "Turret_1_3"]
}

func _ready():
	visible = false
	Economy.connect("coin_updated", Callable(self, "_on_coin_updated"))

# Abre HUD para torre nova
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
	for child in tower_list_container.get_children():
		tower_list_container.remove_child(child)
		child.queue_free()

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

		var button = Button.new()
		button.text = "Evoluir para %s - %d moedas" % [evolution_name, cost]
		button.disabled = not can_buy
		button.modulate = Color(1,1,1,1) if can_buy else Color(0.5,0.5,0.5,0.6)
		button.pressed.connect(func():
			current_base.upgrade_to(scene)
			visible = false
		)
		tower_list_container.add_child(button)

	var sell_button = Button.new()
	sell_button.text = "Vender Torre (+%d moedas)" % int(current_base.build_cost / 2)
	sell_button.pressed.connect(func():
		current_base.sell_tower()
		visible = false
	)
	tower_list_container.add_child(sell_button)

	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(func(): visible = false)
	tower_list_container.add_child(cancel_button)

# Cria HUD inicial de compra de torre
func _render_tower_buttons():
	for child in tower_list_container.get_children():
		tower_list_container.remove_child(child)
		child.queue_free()

	for tower_data in available_towers:
		var scene: PackedScene = tower_data["scene"]
		var icon = tower_data["icon"]
		var name = tower_data["name"]
		var temp_instance = scene.instantiate()
		var cost = temp_instance.build_cost if "build_cost" in temp_instance else 0
		var can_buy = Economy.can_afford(cost)

		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(280, 72)
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER

		var image = TextureRect.new()
		image.texture = icon
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.custom_minimum_size = Vector2(64, 64)
		image.modulate = Color(1, 1, 1, 1) if can_buy else Color(0.5, 0.5, 0.5, 0.6)

		var button = Button.new()
		button.text = "%s - %d moedas" % [name, cost]
		button.disabled = not can_buy
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.modulate = image.modulate

		button.pressed.connect(func():
			if current_base:
				current_base.build_tower(scene)
			visible = false
		)

		hbox.add_child(image)
		hbox.add_child(button)
		tower_list_container.add_child(hbox)

	if current_base and current_base.has_method("is_built") and current_base.is_built:
		var sell_button = Button.new()
		sell_button.text = "Vender Torre (+%d moedas)" % int(current_base.build_cost / 2)
		sell_button.pressed.connect(func():
			current_base.sell_tower()
			visible = false
		)
		tower_list_container.add_child(sell_button)

	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(func():
		visible = false
	)
	tower_list_container.add_child(cancel_button)

# HUD para torres sem mais upgrades (só vender/cancelar)
func _render_sell_only_ui():
	for child in tower_list_container.get_children():
		tower_list_container.remove_child(child)
		child.queue_free()

	var sell_button = Button.new()
	sell_button.text = "Vender Torre (+%d moedas)" % int(current_base.build_cost / 2)
	sell_button.pressed.connect(func():
		current_base.sell_tower()
		visible = false
	)
	tower_list_container.add_child(sell_button)

	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(func(): visible = false)
	tower_list_container.add_child(cancel_button)

# Quando moedas mudam, atualiza HUD se visível
func _on_coin_updated(new_amount: int):
	if not visible:
		return

	match mode:
		"base":
			_render_tower_buttons()
		"upgrade":
			_render_upgrade_buttons()
