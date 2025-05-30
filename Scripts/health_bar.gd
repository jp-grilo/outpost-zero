extends ProgressBar

@onready var health_system := get_parent().get_node_or_null("HealthSystem")

func _ready():
	if health_system:
		max_value = health_system.max_health
		value = health_system.current_health
		# Verifica se o nó principal da cena é Player
		if _is_player():
			show_percentage = true
			_style_health_bar_player()
		else:
			show_percentage = false
			_style_health_bar_enemy()
		# Conecta o sinal de vida alterada apenas no HealthSystem deste nó
		health_system.health_changed.connect(_on_health_changed)
		# Posiciona a barra acima do inimigo
		position = Vector2(-size.x / 2, -20)
	else:
		push_error("⚠️ HealthSystem não encontrado no Slime.")

func _on_health_changed(current, _max):
	value = current

func _is_player() -> bool:
	# Sobe na hierarquia para checar se o avô é o Player
	var outpost_node = get_parent()  # Deve ser OutpostZero (Sprite2D)
	if outpost_node and outpost_node.name == "OutpostZero":
		var parent_node = outpost_node.get_parent()  # Deve ser Player (StaticBody2D)
		if parent_node and parent_node.name == "player":
			return true
	return false

func _style_health_bar_player() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.0)
	style.border_width_left = 0
	style.border_width_top = 0
	style.border_width_right = 0
	style.border_width_bottom = 0
	add_theme_stylebox_override("background", style)
	add_theme_stylebox_override("under", style)

	var style_fill = StyleBoxFlat.new()
	style_fill.bg_color = Color(0.3, 0.7, 1)  # Azul claro para jogador
	style_fill.border_width_left = 0
	style_fill.border_width_top = 0
	style_fill.border_width_right = 0
	style_fill.border_width_bottom = 0
	add_theme_stylebox_override("fill", style_fill)

func _style_health_bar_enemy() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.0)
	style.border_width_left = 0
	style.border_width_top = 0
	style.border_width_right = 0
	style.border_width_bottom = 0
	add_theme_stylebox_override("background", style)
	add_theme_stylebox_override("under", style)

	var style_fill = StyleBoxFlat.new()
	style_fill.bg_color = Color(1, 0, 0)  # Vermelho para inimigo
	style_fill.border_width_left = 0
	style_fill.border_width_top = 0
	style_fill.border_width_right = 0
	style_fill.border_width_bottom = 0
	add_theme_stylebox_override("fill", style_fill)
