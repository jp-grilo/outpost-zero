extends CharacterBody2D

@onready var target = get_tree().get_root().get_node("OutpostZero/player")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar

var base_damage_timer: Timer
var is_in_base: bool = false
var base_ref: StaticBody2D = null

var speed: float = 60.0  # Um pouco mais rápido no ar
var hover_height: float = 50.0  # Altura constante acima da base ou alvo
var vertical_speed: float = 80.0

var show_health_timer: Timer

func _ready():
	health_bar.visible = false
	show_health_timer = Timer.new()
	add_child(show_health_timer)
	show_health_timer.timeout.connect(_hide_health_bar)
	show_health_timer.one_shot = true

	base_damage_timer = Timer.new()
	add_child(base_damage_timer)
	base_damage_timer.timeout.connect(_deal_base_damage)
	base_damage_timer.wait_time = 2.0
	base_damage_timer.one_shot = false

	health_system.health_changed.connect(_on_health_changed)
	health_system.died.connect(_on_death)

	health_bar.max_value = health_system.max_health
	health_bar.value = health_system.current_health

func _physics_process(delta: float) -> void:
	if target != null and target.is_inside_tree():
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed

		# Movimento vertical para simular voo até a altura de hover
		var desired_y = target.global_position.y - hover_height
		var delta_y = desired_y - global_position.y
		velocity.y = clamp(delta_y, -vertical_speed, vertical_speed)

		animated_sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_base_entered(base: StaticBody2D):
	is_in_base = true
	base_ref = base
	base_damage_timer.start()

func _on_base_exited():
	is_in_base = false
	base_ref = null
	base_damage_timer.stop()

func _deal_base_damage():
	if is_in_base and base_ref and base_ref.has_method("take_damage"):
		base_ref.take_damage(1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("arrow"):
		body.queue_free()
		health_system.take_damage(1)
		health_bar.visible = true
		show_health_timer.start(2.0)

func _on_health_changed(current_health: float, max_health: float):
	health_bar.value = current_health
	if current_health < max_health:
		health_bar.visible = true
		show_health_timer.start(2.0)

func _hide_health_bar():
	health_bar.visible = false
	
	# Adicione junto com os outros métodos do inimigo
func take_damage(amount: int):
	health_system.take_damage(amount)
	# Mostra a barra de vida ao receber dano
	health_bar.visible = true
	show_health_timer.start(2.0)  # Mostra por 2 segundos

func _on_death():
	remove_from_group("inimigo_voador")
	queue_free()
