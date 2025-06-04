extends Area2D
class_name Projectile

@export var speed: float = 300.0
@export var damage: float = 1.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()  # Destroi o projétil
