extends Node2D
class_name TowerRT1

# Configurações exportáveis (ajustáveis no Inspector)
#@export var build_cost: int = 50          # [COMPRA] Custo para construir - DESATIVADO
@export var damage: float = 1.0           # Dano por segundo
@export var tower_name: String = "Torre"  # Nome para exibição

# Referências aos nós
@onready var base_sprite: Sprite2D = $Base
@onready var tower_sprite: Sprite2D = $Tower
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flash: Sprite2D = $Tower/Muzzle/MuzzleFlash
#@onready var buy_area: Area2D = $BuyOrUpgrade  # [COMPRA] Área de compra - DESATIVADO
@onready var range_area: Area2D = $Range

# Variáveis de estado
#var is_built: bool = false  # [COMPRA] Estado de construção - DESATIVADO
#var hovered: bool = false   # [COMPRA] Mouse sobre a base - DESATIVADO
var enemy_array: Array = []
var current_target: Node2D = null
var damage_timer: Timer

func _ready():
	# Configuração inicial
	tower_sprite.visible = true  # Torre sempre ativa
	base_sprite.visible = true   # Base sempre visível
	muzzle_flash.visible = false # Flash do cano da arma desligado inicialmente
	
	# Configura timer de dano
	damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_apply_damage)
	damage_timer.start()  # Inicia imediatamente
	
	# [COMPRA] Código de compra comentado
	#buy_area.input_event.connect(_on_buy_area_clicked)
	#buy_area.mouse_entered.connect(_on_buy_area_hover)
	#buy_area.mouse_exited.connect(_on_buy_area_unhover)
	#
	#var shape = CircleShape2D.new()
	#shape.radius = 50
	#buy_area.get_node("CollisionShape2D").shape = shape

func _process(delta):
	pass  # [COMPRA] Removido o processamento de hover
	#if hovered and not is_built:
	#    _show_hover_info()

func _physics_process(delta):
	# Sem verificação de is_built - sempre ativo
	_update_combat()

# --- [COMPRA] Lógica de Construção COMENTADA ---
#func _on_buy_area_clicked(viewport, event, shape_idx):
#    if (event is InputEventMouseButton and 
#        event.button_index == MOUSE_BUTTON_LEFT and 
#        event.pressed):
#        
#        _try_build_tower()
#
#func _try_build_tower():
#    if is_built: return
#    
#    if Economy.spend_coins(build_cost):
#        _complete_build()
#    else:
#        _show_feedback("Moedas insuficientes!")
#
#func _complete_build():
#    is_built = true
#    tower_sprite.visible = true
#    damage_timer.start()
#    
#    if has_node("HoverText"):
#        $HoverText.queue_free()
#    
#    var tween = create_tween()
#    tower_sprite.scale = Vector2(0.5, 0.5)
#    tween.tween_property(tower_sprite, "scale", Vector2.ONE, 0.3)

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
		animation_player.play("Shoot")
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

# --- [COMPRA] Feedback Visual COMENTADO ---
#func _on_buy_area_hover():
#    if not is_built:
#        hovered = true
#
#func _on_buy_area_unhover():
#    hovered = false
#    if has_node("HoverText"):
#        $HoverText.queue_free()
#
#func _show_hover_info():
#    if has_node("HoverText"):
#        $HoverText.queue_free()
#    
#    var text = Label.new()
#    text.name = "HoverText"
#    text.text = "%s\nCusto: %d" % [tower_name, build_cost]
#    text.position = Vector2(0, -60)
#    add_child(text)
#
#func _show_feedback(message):
#    var feedback = Label.new()
#    feedback.text = message
#    feedback.position = Vector2(0, -80)
#    add_child(feedback)
#    await get_tree().create_timer(1.5).timeout
#    feedback.queue_free()
