extends Control

@onready var color_rect = $ColorRect
@onready var vbox = $VBoxContainer
@onready var derrota_label = $VBoxContainer/DerrotaLabel
@onready var restart_button = $VBoxContainer/RestartButton
@onready var menu_button = $VBoxContainer/MenuButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	_apply_button_style(restart_button, "restart")
	_apply_button_style(menu_button, "menu")
	_apply_button_style(quit_button, "quit")

	_apply_overlay_style(color_rect)
	_apply_label_style(derrota_label)

	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/outpost_zero.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/startScreen.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _apply_button_style(button: Button, type: String):
	var theme_color = Color("#d9b3ff")

	match type:
		"restart":
			theme_color = Color("#ffd699")
		"menu":
			theme_color = Color("#b3d9ff")
		"quit":
			theme_color = Color("#ffaaaa")

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
	button.custom_minimum_size = Vector2(0, 48)

func _apply_overlay_style(rect: ColorRect):
	rect.color = Color(0.4, 0.0, 0.0, 0.9)  # vermelho escuro intenso

func _apply_label_style(label: Label):
	label.text = "💀 DERROTA 💀"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	var font = load("res://Assets/Fonts/Orbitron-Bold.ttf") as Font
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color("#ffffff"))
