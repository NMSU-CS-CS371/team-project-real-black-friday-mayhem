extends MeshInstance3D

var speed = 2 
var isMoving = false
var isBackward = false

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("Right", "Left", "Forward", "Backward")
	var direction_ground = Vector3(input_dir.x, 0, input_dir.y)
	if isMoving:
		rotation.y += direction_ground.x * delta * 4
	if isBackward:
		rotation.y += -direction_ground.x * delta * 4
	var forward = direction_ground.rotated(Vector3.UP, rotation.y)
	position += forward * delta * 4
	#position = $"Example Player/Camera3D".global_basis * direction_ground * speed *  4 * delta
	#velocity.y = velocity_y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Forward"):
		isMoving = true
		pass
	if event.is_action_released("Forward"):
		isMoving = false
	if event.is_action_pressed("Backward"):
		isBackward = true
	if event.is_action_released("Backward"):
		isBackward = false
	pass
