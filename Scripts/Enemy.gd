extends CharacterBody2D
class_name Enemy

@onready var target = get_tree().get_root().get_node("OutpostZero/player")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar

@export var coins_reward: int = 0

var base_damage_timer: Timer
var is_in_base: bool = false
var base_ref: StaticBody2D = null

var speed: float = 50.0
var show_health_timer: Timer

func _ready():
	# Timer para esconder barra de vida
	show_health_timer = Timer.new()
	add_child(show_health_timer)
	show_health_timer.timeout.connect(_hide_health_bar)
	show_health_timer.one_shot = true
	
	# Timer de dano na base
	base_damage_timer = Timer.new()
	add_child(base_damage_timer)
	base_damage_timer.timeout.connect(_deal_base_damage)
	base_damage_timer.wait_time = 2.0
	base_damage_timer.one_shot = false

	# Health
	health_bar.visible = false
	health_bar.max_value = health_system.max_health
	health_bar.value = health_system.current_health

	health_system.health_changed.connect(_on_health_changed)
	health_system.died.connect(_on_death)

func _physics_process(delta: float) -> void:
	if target and target.is_inside_tree():
		_move_towards_target(delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _move_towards_target(delta: float) -> void:
	# Implementado nas subclasses
	pass

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
	if current_health < health_system.max_health:
		health_bar.visible = true
		show_health_timer.start(2.0)

func _hide_health_bar():
	health_bar.visible = false

func take_damage(amount: int):
	health_system.take_damage(amount)
	health_bar.visible = true
	show_health_timer.start(2.0)

func _on_death():
	print(coins_reward)
	Economy.add_coins(coins_reward)
	queue_free()
