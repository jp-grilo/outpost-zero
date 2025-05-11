extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0
@export var move_speed: float = 500.0

func _ready():
	make_current()  # Garante que esta câmera está ativa

func _process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if input.length() > 0:
		position += input.normalized() * move_speed * delta * (1/zoom.x)

func _input(event):
	# Zoom com scroll do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(-zoom_speed)
	
	# Botão para resetar a posição (opcional)
	if event.is_action_pressed("center_camera") and get_parent().has_node("Base"):
		position = get_parent().get_node("Base").position

func zoom_camera(amount: float):
	var new_zoom = zoom + Vector2(amount, amount)
	new_zoom = new_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	zoom = new_zoom
