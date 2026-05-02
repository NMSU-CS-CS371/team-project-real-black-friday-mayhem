extends BaseCharacter

var target_position: Vector3
var move_speed := 2.5
var move_range := 10.0
var wait_time := 0.0

var knocked_down := false
var fall_speed := 6.0
var fall_angle := deg_to_rad(90)

func _ready():
	randomize()
	$AnimatedSprite3D.play("default")

	# Standing NPC keeps facing the camera/player.
	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_ENABLED

	pick_new_target()

func _physics_process(delta):
	if knocked_down:
		velocity = Vector3.ZERO

		# After billboard is disabled, this rotation becomes visible.
		rotation.x = move_toward(
			rotation.x,
			fall_angle,
			fall_speed * delta
		)

		return

	if wait_time > 0.0:
		wait_time -= delta
		velocity = Vector3.ZERO
		apply_movement_and_animation(delta)
		return

	var direction = global_position.direction_to(target_position)
	direction.y = 0
	velocity = direction * move_speed

	apply_movement_and_animation(delta)

	if get_slide_collision_count() > 0:
		print("NPC hit something")
		knock_down()
		return

	if global_position.distance_to(target_position) < 0.5:
		wait_time = randf_range(0.5, 2.0)
		pick_new_target()

func knock_down():
	print("NPC knocked down")
	knocked_down = true
	velocity = Vector3.ZERO

	# Turn billboard off only after being knocked down.
	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_DISABLED

	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true

func pick_new_target():
	var offset_x = randf_range(-move_range, move_range)
	var offset_z = randf_range(-move_range, move_range)

	target_position = Vector3(
		global_position.x + offset_x,
		global_position.y,
		global_position.z + offset_z
	)
