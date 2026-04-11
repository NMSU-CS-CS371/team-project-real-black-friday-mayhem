extends Node3D

var target_position: Vector3
var move_speed := 2.5
var move_range := 10.0
var wait_time := 0.0

func _ready():
	randomize()
	$AnimatedSprite3D.play("default")
	pick_new_target()

func _process(delta):
	if wait_time > 0.0:
		wait_time -= delta
		return

	position = position.move_toward(target_position, move_speed * delta)

	if position.distance_to(target_position) < 0.1:
		wait_time = randf_range(0.5, 2.0)
		pick_new_target()

func pick_new_target():
	var offset_x = randf_range(-move_range, move_range)
	var offset_z = randf_range(-move_range, move_range)
	target_position = Vector3(
		position.x + offset_x,
		position.y,
		position.z + offset_z
	)
