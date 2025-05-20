extends Control

@onready var continue_button = $VBoxContainer/ContinueButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # Godot 4

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		var tower_ui = get_tree().get_first_node_in_group("ui")
		if tower_ui and tower_ui.visible:
			tower_ui.visible = false  # fecha só a UI de compra
		else:
			# só abre o menu de pause se a UI de compra não estiver ativa
			toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		get_tree().paused = true
		visible = true

func _on_continue_pressed():
	toggle_pause()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/startScreen.tscn")
