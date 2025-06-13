extends Control

@onready var color_rect = $ColorRect
@onready var vbox = $VBoxContainer
@onready var jogo_pause_label = $VBoxContainer/JogoPause
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var restart_button = $VBoxContainer/RestartButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Ajusta estilo dos botões
	_apply_button_style(continue_button, "continue")
	_apply_button_style(restart_button, "restart")
	_apply_button_style(quit_button, "quit")

	# Ajusta fundo de pausa
	_apply_overlay_style(color_rect)

	# Ajusta label do menu
	_apply_label_style(jogo_pause_label)

	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		var ui_nodes = get_tree().get_nodes_in_group("ui")
		for ui_node in ui_nodes:
			if ui_node and is_instance_valid(ui_node) and ui_node.visible:
				ui_node.visible = false
				return
		toggle_pause()
	elif event is InputEventMouseButton and event.pressed:
		# Se clicou fora do painel
		print("Clique capturado")
		var ui_nodes = get_tree().get_nodes_in_group("ui")
		for ui_node in ui_nodes:
			if ui_node and is_instance_valid(ui_node) and ui_node.visible:
				ui_node.visible = false
				return

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		get_tree().paused = true
		visible = true

func _on_continue_pressed():
	toggle_pause()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/outpost_zero.tscn")

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/startScreen.tscn")

func _apply_button_style(button: Button, type: String):
	var theme_color = Color("#d9b3ff")  # roxo clarinho base

	match type:
		"continue":
			theme_color = Color("#b3d9ff")  # azul clarinho
		"restart":
			theme_color = Color("#ffd699")  # laranja clarinho
		"quit":
			theme_color = Color("#ffaaaa")  # vermelho clarinho

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

	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.custom_minimum_size = Vector2(0, 48)  # altura mais compacta

func _apply_overlay_style(rect: ColorRect):
	rect.color = Color(0.1, 0.1, 0.1, 0.75)  # fundo escuro com transparência

func _apply_label_style(label: Label):
	label.text = "🚀 Menu de Pausa"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color("#ffffff"))
