extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  

var speed = 300
var direction = 1

func _ready():
	update_sprite_direction()  

func set_direction(dir, spd):
	direction = dir
	speed = spd
	update_sprite_direction() 

func update_sprite_direction():
	if direction == -1:
		animated_sprite_2d.flip_h = true 
	else:
		animated_sprite_2d.flip_h = false

func _physics_process(delta):
	velocity.x = direction * speed
	move_and_slide()
	
	# Remove se sair da tela
	if position.length() > 1000:
		queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		queue_free()
		if body.has_method("take_damage"):
			body.take_damage(1)
