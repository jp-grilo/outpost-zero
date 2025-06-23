extends Enemy

var gravity: float = 500.0

func _ready():
	coins_reward = 15
	speed = 60          # Mais rápido que o tank
	health_system.max_health = 80
	add_to_group("inimigo_terrestre")
	super()

func _move_towards_target(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	animated_sprite.flip_h = direction.x < 0
