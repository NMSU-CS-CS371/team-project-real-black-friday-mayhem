extends EntityMovement

var target_position: Vector3
var move_speed := 2.5
var move_range := 10.0
var wait_time := 0.0

func _ready():
	randomize()
	$AnimatedSprite3D.play("default")
	pick_new_target()

func _physics_process(delta):
	if wait_time > 0.0:
		wait_time -= delta
		velocity = Vector3.ZERO
		apply_movement_and_animation(delta)
		return

	# Move toward target using velocity
	var direction = global_position.direction_to(target_position)
	direction.y = 0 # keep it 2d mostly
	velocity = direction * move_speed
	
	# Apply physics from base class
	apply_movement_and_animation(delta)

	# Check if reached target or stuck
	if global_position.distance_to(target_position) < 0.5 or get_slide_collision_count() > 0:
		wait_time = randf_range(0.5, 2.0)
		pick_new_target()

func pick_new_target():
	var offset_x = randf_range(-move_range, move_range)
	var offset_z = randf_range(-move_range, move_range)
	target_position = Vector3(
		global_position.x + offset_x,
		global_position.y,
		global_position.z + offset_z
	)
