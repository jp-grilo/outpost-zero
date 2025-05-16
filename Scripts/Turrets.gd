extends Node2D
class_name TowerRT1

# Configurações exportáveis (ajustáveis no Inspector)
@export var build_cost: int = 50          # Custo para construir
@export var damage: float = 1.0           # Dano por segundo
@export var tower_name: String = "Torre"  # Nome para exibição

# Referências aos nós
@onready var buyorupgrade = $BuyOrUpgrade
@onready var base_sprite: Sprite2D = $Base
@onready var tower_sprite: Sprite2D = $Tower
#@onready var buy_area: Area2D = $BuyOrUpgrade
@onready var range_area: Area2D = $Range

# Variáveis de estado
var is_built: bool = false
var hovered: bool = false
var enemy_array: Array = []
var current_target: Node2D = null
var damage_timer: Timer

func _ready():
	# Configuração inicial
	buyorupgrade.pressed.connect(_on_buy_area_clicked)
	tower_sprite.visible = false  # Torre começa invisível
	base_sprite.visible = true    # Base sempre visível
	
	# Configura timer de dano
	damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_apply_damage)
	
	# Conecta sinais da área de compra
	#buy_area.input_event.connect(_on_buy_area_clicked)
	#buy_area.mouse_entered.connect(_on_buy_area_hover)
	#buy_area.mouse_exited.connect(_on_buy_area_unhover)
	#_complete_build()
	# Configura colisão
	#_complete_build()
	var shape = CircleShape2D.new()
	shape.radius = 50  # Ajuste conforme tamanho da base
	#buy_area.get_node("CollisionShape2D").shape = shape
		
func _process(delta):
	# Mostra/oculta texto de hover
	if hovered and not is_built:
		_show_hover_info()

func _physics_process(delta):
	if is_built:
		_update_combat()

# --- Lógica de Construção ---
func _on_buy_area_clicked(viewport, event, shape_idx):
	print("Entrei")
	_try_build_tower()

func _try_build_tower():
	if is_built: return
	print("Entrei aqui")
	if Economy.spend_coins(build_cost):
		print("Entrei no complete")
		_complete_build()
	else:
		print(Economy.current_coins)
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
		current_target = enemy_array[0]
		_aim_tower()

func _aim_tower():
	if current_target:
		var direction = (current_target.global_position - global_position).normalized()
		tower_sprite.rotation = atan2(direction.y, direction.x) + PI/2

func _apply_damage():
	if current_target and current_target.has_method("take_damage"):
		current_target.take_damage(damage)

# --- Detecção de Inimigos ---
func _on_range_body_entered(body):
	if body.is_in_group("enemies"):
		enemy_array.append(body)
		enemy_array.sort_custom(_sort_by_distance)

func _on_range_body_exited(body):
	if body in enemy_array:
		enemy_array.erase(body)

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
