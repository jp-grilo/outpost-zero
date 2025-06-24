extends Control

@onready var tutorial_hud = $Tutorial_HUD
@onready var tutorial_image = $Tutorial_HUD/TextureRect
@onready var imagens = [
	preload("res://assets/sprites/tutorial/01 tutorial.png"),
	preload("res://assets/sprites/tutorial/02 tutorial.png"),
	preload("res://assets/sprites/tutorial/3 tutorial.png"),
	preload("res://assets/sprites/tutorial/04 tutorial.png"),
	preload("res://assets/sprites/tutorial/05 tutorial.png"),
	preload("res://assets/sprites/tutorial/06.png"),
]

var indice = 0

func _ready():
	tutorial_hud.visible = false
	tutorial_image.texture = imagens[indice]
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_help_button_pressed() -> void:
	tutorial_hud.visible = true
	indice = 0
	tutorial_image.texture = imagens[indice]
	get_tree().paused = true

func _on_botao_anterior_pressed() -> void:
	if indice > 0:
		indice -= 1
		tutorial_image.texture = imagens[indice]

func _on_botao_proximo_pressed() -> void:
	if indice < imagens.size() - 1:
		indice += 1
		tutorial_image.texture = imagens[indice]

func _on_botao_fechar_pressed() -> void:
	tutorial_hud.visible = false
	get_tree().paused = false
