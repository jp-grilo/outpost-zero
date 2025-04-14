extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const ARROW = preload("res://Scenes/arrow.tscn")
const ARROW_SPEED = 300.0
const ARROW_OFFSET = Vector2(25, -10) 

var shoot_timer = 0.0

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# --- Sistema de disparo automático adicionado ---
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot_arrow()
		shoot_timer = 1.0

func shoot_arrow():
	var arrow = ARROW.instantiate()
	get_parent().add_child(arrow)
	
	var direction = -1 if animated_sprite.flip_h else 1
	arrow.position = position + Vector2(ARROW_OFFSET.x * direction, ARROW_OFFSET.y)
	arrow.set_direction(direction, ARROW_SPEED)
