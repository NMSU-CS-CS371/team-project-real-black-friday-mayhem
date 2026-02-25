extends MeshInstance3D

var speed = 2 

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction_ground = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, $"CharacterBody3D/Example Player/Camera3D".rotation.y)
	position = lerp(position, direction_ground * speed, 4 * delta)
	#velocity.y = velocity_y
	pass
