extends CharacterBody2D

@onready var target = $"../player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 50.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Vector2(target.position.x - position.x, 0).normalized()
	velocity.x = direction.x * SPEED
	velocity.y = velocity.y
	
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
		
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().reload_current_scene()
	elif body.is_in_group("arrow"):  # Detecta flechas
		body.queue_free()  # Destrói a flecha
		queue_free()  # Destrói o Slime
