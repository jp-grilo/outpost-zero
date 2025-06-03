extends Control

@onready var continue_button = $VBoxContainer/ContinueButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var restart_button = $VBoxContainer/RestartButton

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # Godot 4

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		var ui_nodes = get_tree().get_nodes_in_group("ui")
		for ui_node in ui_nodes:
			if ui_node and is_instance_valid(ui_node) and ui_node.visible:
				ui_node.visible = false
				return  # Fecha apenas uma aba por vez
		# Se nenhum painel estava visível, abre o menu de pausa
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
	
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/outpost_zero.tscn")
