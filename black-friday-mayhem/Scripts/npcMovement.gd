extends RigidBody3D

var target_offset: Vector3
@export var move_speed := 2.5
@export var move_range := 10.0
@export var wait_time := 0.0

func _ready() -> void:
	pick_new_target()
	pass

func look_follow(state: PhysicsDirectBodyState3D, current_transform: Transform3D, target_position: Vector3) -> void:
	var forward_local_axis: Vector3 = Vector3(1, 0, 0)
	var forward_dir: Vector3 = (current_transform.basis * forward_local_axis).normalized()
	var target_dir: Vector3 = (target_position - current_transform.origin).normalized()
	var local_speed: float = clampf(move_speed, 0, acos(forward_dir.dot(target_dir)))
	if forward_dir.dot(target_dir) > 1e-4:
		state.angular_velocity = local_speed * forward_dir.cross(target_dir) / state.step

func _integrate_forces(state):
	if global_transform.origin.distance_to(target_offset) < 0.1:
		pick_new_target()
	look_follow(state, global_transform, target_offset)

func pick_new_target():
	var offset_x = randf_range(-move_range, move_range)
	var offset_z = randf_range(-move_range, move_range)
	target_offset = Vector3(
		global_transform.origin.x + offset_x,
		global_transform.origin.y,
		global_transform.origin.z + offset_z
	)


func _on_timer_timeout() -> void:
	pick_new_target()
	pass # Replace with function body.
