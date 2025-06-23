extends Enemy

var hover_height: float = 50.0
var vertical_speed: float = 100.0  # mais ágil verticalmente

func _ready():
	coins_reward = 15
	speed = 70           # rápido na horizontal
	health_system.max_health = 50
	add_to_group("inimigo_voador")
	super()
	
func _deal_base_damage():
	if is_in_base and base_ref and base_ref.has_method("take_damage"):
		base_ref.take_damage(2)
		
func _move_towards_target(delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * speed

	var desired_y = target.global_position.y - hover_height
	var delta_y = desired_y - global_position.y
	velocity.y = clamp(delta_y, -vertical_speed, vertical_speed)

	animated_sprite.flip_h = direction.x < 0
