extends ProgressBar

@onready var health_system := get_node_or_null("/root/OutpostZero/player/OutpostZero/HealthSystem")

func _ready():
	if health_system:
		max_value = health_system.max_health
		value = health_system.current_health

		show_percentage = true
		_style_health_bar_player()

		health_system.health_changed.connect(_on_health_changed)
		
		# Aumentar tamanho da barra de vida
		custom_minimum_size = Vector2(400, 9)  # largura x altura
	else:
		push_error("⚠️ HealthSystem não encontrado.")
	anchor_left = 0
	anchor_top = 0
	anchor_right = 0
	anchor_bottom = 0


func _on_health_changed(current, _max):
	value = current
	
func _style_health_bar_player() -> void:
	# Estilo de fundo com borda arredondada
	var style_bg = StyleBoxFlat.new()
	style_bg.bg_color = Color(0.1, 0.1, 0.1, 1.0)  # Cor de fundo escuro
	style_bg.border_color = Color(0.8, 0.1, 0.1, 1)     # Borda branca
	style_bg.border_width_left = 2
	style_bg.border_width_right = 2
	style_bg.border_width_top = 2
	style_bg.border_width_bottom = 2
	style_bg.corner_radius_top_left = 8
	style_bg.corner_radius_top_right = 8
	style_bg.corner_radius_bottom_left = 8
	style_bg.corner_radius_bottom_right = 8
	add_theme_stylebox_override("background", style_bg)

	# Estilo do preenchimento com os mesmos cantos arredondados
	var style_fill = StyleBoxFlat.new()
	style_fill.bg_color = Color(0.8, 0.1, 0.1, 1)  # Azul da barra de vida
	style_fill.corner_radius_top_left = 8
	style_fill.corner_radius_top_right = 8
	style_fill.corner_radius_bottom_left = 8
	style_fill.corner_radius_bottom_right = 8

	# IMPORTANTE: não adicione margens, elas quebram o alinhamento da borda
	add_theme_stylebox_override("fill", style_fill)
