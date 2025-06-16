extends Button

var upgrades = [
	{ "cost": 150, "action": _build_base },
	{ "cost": 350, "action": _unlock_tower },
	{ "cost": 550, "action": _expand_area },
	{ "cost": 100000, "action": _finalize_phase }
]

var current_stage := 0

func _ready():
	pressed.connect(_on_pressed)
	_apply_button_style(Color("#ffaa00"))
	_update_button_text()

func _on_pressed():
	if current_stage >= upgrades.size():
		disabled = true
		return

	var upgrade = upgrades[current_stage]
	var cost = upgrade["cost"]
	var action = upgrade["action"]

	if Economy.can_afford(cost):
		Economy.spend_coins(cost)
		action.call()
		current_stage += 1
		_update_button_text()
	else:
		print("Moedas insuficientes")

func _update_button_text():
	if current_stage < upgrades.size() - 1:
		text = "Restaurar (%d⭐)" % upgrades[current_stage]["cost"]
	elif current_stage == upgrades.size() - 1:
		text = "Próxima Fase (%d⭐)" % upgrades[current_stage]["cost"]
	else:
		text = "Completo"
		disabled = true

func _apply_button_style(base_color: Color):
	var style = StyleBoxFlat.new()
	style.bg_color = base_color.darkened(0.2)
	style.border_color = base_color.lightened(0.5)
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0, 0, 0, 0.6)
	style.shadow_size = 6
	style.anti_aliasing = true

	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("hover", style)
	add_theme_stylebox_override("pressed", style)

	add_theme_font_size_override("font_size", 20)
	add_theme_color_override("font_color", Color.WHITE)

# Ações de upgrade
func _build_base():
	var sprite = get_node_or_null("/root/OutpostZero/Cenário")
	if sprite:
		sprite.texture = preload("res://assets/sprites/CENARIO_OZ V1.1/Cenario2.png")

func _unlock_tower():
	var sprite = get_node_or_null("/root/OutpostZero/Cenário")
	var torre1 = get_node_or_null("/root/OutpostZero/Turrets/Turrets2")
	var torre2 = get_node_or_null("/root/OutpostZero/Turrets/Turrets4")

	if sprite:
		sprite.texture = preload("res://assets/sprites/CENARIO_OZ V1.1/Cenario3_TorreDireita.png")
	if torre1:
		torre1.visible = true
	if torre2:
		torre2.visible = true

func _expand_area():
	var sprite = get_node_or_null("/root/OutpostZero/Cenário")
	var torre1 = get_node_or_null("/root/OutpostZero/Turrets/Turrets")
	var torre2 = get_node_or_null("/root/OutpostZero/Turrets/Turrets3")

	if sprite:
		sprite.texture = preload("res://assets/sprites/CENARIO_OZ V1.1/Cenario4_Final.png")
	if torre1:
		torre1.visible = true
	if torre2:
		torre2.visible = true

func _finalize_phase():
	print("Fase concluída!")

	# Atualiza progresso global
	Global.progresso_fase = 2  # Ou += 1 se for dinâmica

	# Vai para o menu de seleção
	get_tree().change_scene_to_file("res://Scenes/menu_selecao_fase.tscn")
