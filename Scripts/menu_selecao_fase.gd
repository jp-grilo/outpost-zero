extends Control

var progresso: int = Global.progresso_fase

var imagens_fundo = {
	1: preload("res://assets/sprites/Planetas/Planetas1.png"),
	2: preload("res://assets/sprites/Planetas/Planetas2.png"),
	3: preload("res://assets/sprites/Planetas/Planetas3.png"),
	4: preload("res://assets/sprites/Planetas/Planetas4.png"),
}

func _ready():
	# Define o fundo de acordo com o progresso
	if progresso < 5:
		$Fundo.texture = imagens_fundo[progresso]
	else: 
		$Fundo.texture = imagens_fundo[4]
	# Habilita os botões conforme o progresso
	$BotaoLua.disabled = false
	$BotaoTerrys.disabled = progresso < 2
	$BotaoFerin.disabled = progresso < 3
	$BotaoLaz.disabled = progresso < 4

	# Conecta os sinais dos botões
	$BotaoLua.pressed.connect(_on_BotaoLua_pressed)
	$BotaoTerrys.pressed.connect(_on_BotaoTerrys_pressed)
	$BotaoFerin.pressed.connect(_on_BotaoFerin_pressed)
	$BotaoLaz.pressed.connect(_on_BotaoLaz_pressed)
	$voltar.pressed.connect(_on_Voltar_pressed)

func _on_BotaoLua_pressed():
	var menu_fase = preload("res://Scenes/outpost_zero.tscn")
	get_tree().change_scene_to_packed(menu_fase)

func _on_BotaoTerrys_pressed():
	var menu_fase = preload("res://Scenes/outpost_zero.tscn")
	get_tree().change_scene_to_packed(menu_fase)

func _on_BotaoFerin_pressed():
	var menu_fase = preload("res://Scenes/outpost_zero.tscn")
	get_tree().change_scene_to_packed(menu_fase)

func _on_BotaoLaz_pressed():
	var menu_fase = preload("res://Scenes/outpost_zero.tscn")
	get_tree().change_scene_to_packed(menu_fase)
	
func _on_Voltar_pressed():
	print("Voltar apertado")
	get_tree().change_scene_to_file("res://Scenes/startScreen.tscn")
