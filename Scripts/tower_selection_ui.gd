extends Control

var current_base: Node = null

@onready var tower_list_container = $Panel/TowerList

var available_towers = [
	{
		"name": "Metralhadora",
		"scene": preload("res://Scenes/tower_lt_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk1.PNG")
	},
	{
		"name": "Metralhadora-Dupla",
		"scene": preload("res://Scenes/tower_rt_1.tscn"),
		"icon": preload("res://assets/sprites/armas/turret_01_mk2.PNG")
	},
]

func _ready():
	visible = false

func open_tower_selection(base_node):
	current_base = base_node
	visible = true
	_render_tower_buttons()

func _render_tower_buttons():
	for child in tower_list_container.get_children():
		tower_list_container.remove_child(child)
		child.queue_free()

	for tower_data in available_towers:
		var scene: PackedScene = tower_data["scene"]
		var icon = tower_data["icon"]
		var name = tower_data["name"]
		var temp_instance = scene.instantiate()
		var cost = 0
		if "build_cost" in temp_instance:
			cost = temp_instance.build_cost

		var can_buy = Economy.current_coins >= cost

		# Criar container horizontal
		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(280, 72)
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER

		# Imagem da torre
		var image = TextureRect.new()
		image.texture = icon
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.custom_minimum_size = Vector2(64, 64)
		image.modulate = Color(1, 1, 1, 1) if can_buy else Color(0.5, 0.5, 0.5, 0.6)

		# Botão de compra
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
		
		# Botão de vender torre (se já construída)
	print(current_base.has_method("is_built"))
	if current_base and current_base.is_built:
		var sell_button = Button.new()
		sell_button.text = "Vender Torre (+%d moedas)" % int(current_base.build_cost / 2)
		sell_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sell_button.pressed.connect(func():
			current_base.sell_tower()
			visible = false
		)
		tower_list_container.add_child(sell_button)

	# Botão de cancelar
	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cancel_button.pressed.connect(func():
		visible = false
	)
	tower_list_container.add_child(cancel_button)
