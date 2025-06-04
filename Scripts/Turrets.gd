extends Node2D
class_name Turrets

# ---------------------------------------------------
# VARIÁVEIS ESTÁTICAS E EXPORTADAS (Inspector)
# ---------------------------------------------------

static var current_upgrade_hud: Node = null

# Configurações da torre (ajustáveis no editor)
@export var build_cost: int = 50
@export var damage: float = 1.0
@export var fire_rate: float = 1.0
@export var range: float = 100.0
@export var range_direction: String = "center"  # "left", "right", "center"
@export var tower_name: String = "Torre"
@export var projectile_scene: PackedScene  # Cena de projétil a ser instanciada

# ---------------------------------------------------
# REFERÊNCIAS A NÓS INTERNOS
# ---------------------------------------------------

@onready var buyorupgrade = $BuyOrUpgrade
@onready var base_sprite: Sprite2D = $Base
@onready var tower_sprite: AnimatedSprite2D = $Tower
@onready var buy_area: Area2D = $BuyOrUpgrade
@onready var range_area: Area2D = $Range

# ---------------------------------------------------
# ESTADO E CONFIGURAÇÕES DE UPGRADE
# ---------------------------------------------------

var upgrade_levels = {}
var upgrade_costs = {}
var upgrade_stats = {}

var is_built: bool = false
var hovered: bool = false
var enemy_array: Array = []
var current_target: Node2D = null
var damage_timer: Timer

# ---------------------------------------------------
# FUNÇÕES DE CICLO DE VIDA
# ---------------------------------------------------

func _ready():
	tower_sprite.visible = false
	base_sprite.visible = true
	
	# Inicializa o temporizador de ataque
	damage_timer = Timer.new()
	damage_timer.wait_time = fire_rate
	damage_timer.timeout.connect(_apply_damage)
	damage_timer.one_shot = false
	add_child(damage_timer)

	# Conecta os sinais da área de construção
	buy_area.input_event.connect(_on_buy_area_clicked)
	buy_area.mouse_entered.connect(_on_buy_area_hover)
	buy_area.mouse_exited.connect(_on_buy_area_unhover)

	# Configura o alcance com base no range definido
	var shape = RectangleShape2D.new()
	var collision_shape = range_area.get_node("CollisionShape2D")
	var current_shape = collision_shape.shape
	
	if current_shape is RectangleShape2D:
		shape.extents.y = current_shape.extents.y
	else:
		shape.extents.y = 50

	shape.extents.x = range / 2.0
	collision_shape.shape = shape

	match range_direction:
		"left": collision_shape.position.x = -range / 4.0
		"right": collision_shape.position.x = range / 4.0
		"center": collision_shape.position.x = 0

func _physics_process(_delta):
	if is_built:
		_update_combat()

# ---------------------------------------------------
# CONSTRUÇÃO, VENDA E EVOLUÇÃO
# ---------------------------------------------------

func build_tower(scene: PackedScene):
	if is_built: return

	var torre = scene.instantiate()
	torre.global_position = global_position

	if Economy.spend_coins(torre.build_cost):
		get_parent().add_child(torre)
		if torre.has_method("_complete_build"):
			torre._complete_build()
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.visible = false
		queue_free()
	else:
		_show_feedback("Moedas insuficientes!")

func _complete_build():
	is_built = true
	add_to_group("built_towers")
	tower_sprite.visible = true
	damage_timer.wait_time = fire_rate
	damage_timer.start()

	if has_node("HoverText"):
		$HoverText.queue_free()

	var tween = create_tween()
	tower_sprite.scale = Vector2(0.5, 0.5)
	tween.tween_property(tower_sprite, "scale", Vector2.ONE, 0.3)

func sell_tower():
	if not is_built:
		_show_feedback("Nada para vender.")
		return

	var refund = int(build_cost / 2)
	var ui = get_tree().get_first_node_in_group("ui")
	if ui == null:
		_show_feedback("Erro: interface não encontrada.")
		return

	var min_cost = INF
	for tower_data in ui.available_towers:
		var scene: PackedScene = tower_data["scene"]
		var temp_instance = scene.instantiate()
		if "build_cost" in temp_instance:
			min_cost = min(min_cost, temp_instance.build_cost)

	if Economy.get_current_coins() + refund < min_cost:
		_show_feedback("Não é seguro vender! Você ficaria sem dinheiro para comprar outra torre.")
		return

	Economy.add_coins(refund)

	var tween = create_tween()
	tween.tween_property(tower_sprite, "scale", Vector2(0.5, 0.5), 0.3)
	await tween.finished

	is_built = false
	tower_sprite.visible = false
	damage_timer.stop()

	if has_node("HoverText"):
		$HoverText.queue_free()

	_show_feedback("Torre vendida por %d moedas!" % refund)

func upgrade_to(scene: PackedScene):
	var upgraded_tower = scene.instantiate()
	upgraded_tower.global_position = global_position

	if Economy.spend_coins(upgraded_tower.build_cost):
		get_parent().add_child(upgraded_tower)
		if upgraded_tower.has_method("_complete_build"):
			upgraded_tower._complete_build()
		queue_free()
	else:
		_show_feedback("Moedas insuficientes para evoluir!")

# ---------------------------------------------------
# COMBATE
# ---------------------------------------------------

func _update_combat():
	enemy_array = enemy_array.filter(func(e): return is_instance_valid(e))
	if enemy_array.size() > 0:
		var target = enemy_array[0]
		if is_instance_valid(target):
			current_target = target
			_aim_tower()
		else:
			current_target = null
	else:
		current_target = null

func _aim_tower():
	if current_target and is_instance_valid(current_target):
		var direction = (current_target.global_position - global_position).normalized()
		tower_sprite.rotation = atan2(direction.y, direction.x) + PI/2
	else:
		current_target = null

func _apply_damage():
	if current_target and is_instance_valid(current_target):
		if not projectile_scene:
			print("Erro: projectile_scene não configurado.")
			return
		
		var projectile = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		projectile.direction = (current_target.global_position - global_position).normalized()
		projectile.damage = damage
	else:
		current_target = null

# ---------------------------------------------------
# DETECÇÃO DE INIMIGOS
# ---------------------------------------------------

func _on_range_body_entered(body):
	if body.is_in_group("enemies"):
		enemy_array.append(body)
		enemy_array.sort_custom(_sort_by_distance)

func _on_range_body_exited(body):
	if body in enemy_array:
		enemy_array.erase(body)
		if body == current_target:
			current_target = null

func _sort_by_distance(a, b):
	if is_instance_valid(a) and is_instance_valid(b):
		return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
	else:
		return 0

# ---------------------------------------------------
# INTERAÇÃO COM UI / HOVER / SELEÇÃO
# ---------------------------------------------------

func _on_buy_area_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if current_upgrade_hud and is_instance_valid(current_upgrade_hud):
				current_upgrade_hud.queue_free()
				current_upgrade_hud = null

			var ui_node = get_tree().get_first_node_in_group("ui")
			if ui_node:
				if is_built:
					ui_node.open_upgrade_selection(self)
				else:
					ui_node.open_tower_selection(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if is_built:
				_open_upgrade_floating_ui()

func _on_buy_area_hover():
	if not is_built:
		hovered = true

func _on_buy_area_unhover():
	hovered = false
	if has_node("HoverText"):
		$HoverText.queue_free()

func _show_hover_info():
	if has_node("HoverText"):
		$HoverText.queue_free()

	var text = Label.new()
	text.name = "HoverText"
	text.text = "%s\nCusto: %d" % [tower_name, build_cost]
	text.position = Vector2(0, -60)
	add_child(text)

func _show_feedback(message):
	var feedback = Label.new()
	feedback.text = message
	feedback.position = Vector2(0, -80)
	add_child(feedback)
	await get_tree().create_timer(1.5).timeout
	feedback.queue_free()

func _open_selection_ui():
	var ui_node = get_tree().get_first_node_in_group("ui")
	if ui_node:
		ui_node.open_tower_selection(self)

func _open_upgrade_floating_ui():
	print("Tentando abrir HUD de upgrade...")

	if current_upgrade_hud and is_instance_valid(current_upgrade_hud):
		current_upgrade_hud.queue_free()

	var hud_scene = preload("res://Scenes/upgradeTurrets.tscn")
	if not hud_scene:
		print("ERRO: Cena não encontrada!")
		return

	var hud_instance = hud_scene.instantiate()
	if not hud_instance:
		print("ERRO: Falha ao instanciar HUD!")
		return

	get_tree().current_scene.add_child(hud_instance)
	hud_instance.add_to_group("ui")
	current_upgrade_hud = hud_instance
	hud_instance.set_tower(self)

# ---------------------------------------------------
# SISTEMA DE MELHORIA POR ATRIBUTOS
# ---------------------------------------------------

func try_upgrade_attribute(attribute: String) -> void:
	if not upgrade_levels.has(attribute):
		_show_feedback("Atributo inválido: %s" % attribute)
		return

	var level = upgrade_levels[attribute]
	if level >= 3:
		_show_feedback("%s já está no nível máximo!" % attribute.capitalize())
		return

	var cost = upgrade_costs[attribute][level]
	if not Economy.can_afford(cost):
		_show_feedback("Moedas insuficientes para melhorar %s." % attribute.capitalize())
		return

	Economy.spend_coins(cost)
	upgrade_levels[attribute] += 1

	match attribute:
		"damage":
			damage = upgrade_stats["damage"][upgrade_levels["damage"]]
		"fire_rate":
			fire_rate = upgrade_stats["fire_rate"][upgrade_levels["fire_rate"]]
			if damage_timer:
				damage_timer.wait_time = fire_rate
		"range":
			print("Legal")  # Placeholder para futura implementação

	_show_feedback("%s melhorado para nível %d!" % [attribute.capitalize(), upgrade_levels[attribute]])
