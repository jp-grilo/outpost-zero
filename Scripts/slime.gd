extends Enemy

var gravity: float = 500.0

func _ready():
	coins_reward = 20  # Define o valor para esse inimigo
	super()  # Chama _ready do pai

func _move_towards_target(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	animated_sprite.flip_h = direction.x < 0
