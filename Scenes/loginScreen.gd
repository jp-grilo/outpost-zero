extends Control

@onready var button_play = $MarginContainer/MenuButtons/ButtonPlay
@onready var button_options = $MarginContainer/MenuButtons/ButtonOptions
@onready var button_exit = $MarginContainer/MenuButtons/ButtonExit

func _ready():
	button_play.pressed.connect(_on_play_pressed)
	button_options.pressed.connect(_on_options_pressed)
	button_exit.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/outpost_zero.tscn")

func _on_options_pressed():
	print("Abrir tela de opções futuramente")

func _on_exit_pressed():
	get_tree().quit()
