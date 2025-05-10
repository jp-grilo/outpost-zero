extends CharacterBody2D

@onready var target = get_tree().get_root().get_node("OutpostZero/player")  # Caminho absoluto até o player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var life: int = 10
var speed: float = 50.0
var gravity: float = 500.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if target != null and target.is_inside_tree():
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		animated_sprite.flip_h = direction.x < 0
	else:
		velocity.x = 0

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().reload_current_scene()
	elif body.is_in_group("arrow"):
		body.queue_free()
		take_damage(5)

func take_damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		remove_from_group("inimigo")  # remove antes de morrer
		queue_free()
