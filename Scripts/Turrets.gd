extends Node2D

var enemy_array = []
var current_target: Node2D = null
var damage_timer: Timer

func _ready():
	# Configura o timer de dano (1 segundo)
	damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_apply_damage)
	damage_timer.start()
	
	# Conecta os sinais da área de detecção
	$Range.body_entered.connect(_on_range_body_entered)
	$Range.body_exited.connect(_on_range_body_exited)

func _physics_process(delta: float) -> void:
	# Limpa inimigos inválidos
	enemy_array = enemy_array.filter(func(enemy): return is_instance_valid(enemy))
	
	# Seleciona o alvo mais próximo
	if enemy_array.size() > 0:
		current_target = enemy_array[0]
		turn()
	else:
		current_target = null

func turn():
	if current_target:
		var direction = (current_target.global_position - global_position).normalized()
		$Tower.rotation = atan2(direction.y, direction.x) + PI/2  # Correção de 90°

func _apply_damage():
	if current_target and current_target.has_method("take_damage"):
		current_target.take_damage(1)  # 1 de dano por segundo

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemy_array.append(body)
		# Ordena por distância (mais próximo primeiro)
		enemy_array.sort_custom(func(a, b): 
			return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))

func _on_range_body_exited(body: Node2D) -> void:
	if body in enemy_array:
		enemy_array.erase(body)
		if body == current_target:
			current_target = null
