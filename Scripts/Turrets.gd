extends Node2D
class_name Turrets

# Configurações exportáveis (ajustáveis no Inspector)
@export var build_cost: int = 50          # Custo para construir
@export var damage: float = 1.0           # Dano por segundo
@export var tower_name: String = "Torre"  # Nome para exibição

# Referências aos nós
@onready var buyorupgrade = $BuyOrUpgrade
@onready var base_sprite: Sprite2D = $Base
@onready var tower_sprite: Sprite2D = $Tower
@onready var buy_area: Area2D = $BuyOrUpgrade
@onready var range_area: Area2D = $Range

# Variáveis de estado
var is_built: bool = false
var hovered: bool = false
var enemy_array: Array = []
var current_target: Node2D = null
var damage_timer: Timer

func _ready():
	# Configuração inicial
	tower_sprite.visible = false  # Torre começa invisível
	base_sprite.visible = true    # Base sempre visível
	
	# Configura timer de dano
	damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_apply_damage)
	
	# Conecta sinais da área de compra
	buy_area.input_event.connect(_on_buy_area_clicked)
	buy_area.mouse_entered.connect(_on_buy_area_hover)
	buy_area.mouse_exited.connect(_on_buy_area_unhover)

	# Configura colisão
	var shape = CircleShape2D.new()
	shape.radius = 50  # Ajuste conforme tamanho da base
	buy_area.get_node("CollisionShape2D").shape = shape
		
func _process(delta):
	# Mostra/oculta texto de hover
	if hovered and not is_built:
		_show_hover_info()

func _physics_process(delta):
	if is_built:
		_update_combat()

# --- Lógica de Construção ---
func _on_buy_area_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		if not is_built:
			print("Abriu")
			_open_selection_ui()
			
func _open_selection_ui():
	var ui_node = get_tree().get_first_node_in_group("ui")
	if ui_node:
		ui_node.open_tower_selection(self)

func build_tower(scene: PackedScene):
	if is_built: return

	var torre = scene.instantiate()
	torre.global_position = global_position

	if Economy.spend_coins(torre.build_cost):
		get_parent().add_child(torre)

		if torre.has_method("_complete_build"):
			torre._complete_build()

		# FECHA A UI de compra
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.visible = false

		queue_free()
	else:
		_show_feedback("Moedas insuficientes!")

func _complete_build():
	is_built = true
	tower_sprite.visible = true
	damage_timer.start()
	
	# Remove texto de hover
	if has_node("HoverText"):
		$HoverText.queue_free()
	
	# Animação de construção
	var tween = create_tween()
	tower_sprite.scale = Vector2(0.5, 0.5)
	tween.tween_property(tower_sprite, "scale", Vector2.ONE, 0.3)

# --- Lógica de Combate ---
func _update_combat():
	# Filtra inimigos válidos
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
	if current_target and is_instance_valid(current_target) and current_target.has_method("take_damage"):
		current_target.take_damage(damage)
	else:
		current_target = null

# --- Detecção de Inimigos ---
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
	return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)

# --- Feedback Visual ---
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
