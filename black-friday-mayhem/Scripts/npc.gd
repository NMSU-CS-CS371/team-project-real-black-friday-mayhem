extends Node3D

var target_position: Vector3
@export var move_speed := 2.5
@export var move_range := 10.0
@export var wait_time := 0.0

func _ready():
	randomize()
	$RigidBody3D/AnimatedSprite3D.play("default")

#func _physics_process(delta: float) -> void:
	#if wait_time > 0.0:
		#wait_time -= delta
		#return
	#rotation.z = 0
	#rotation.x = 0
	#var direction = Vector3.UP.rotated(Vector3.FORWARD, rotation.y) * speed
	#rot_dir = rot_dir * speed * delta
	#$RigidBody3D.linear_velocity = rot_dir * speed * delta
	#position = position.move_toward(target_position, move_speed * delta)

	#if position.distance_to(target_position) < 0.1:
		#wait_time = randf_range(0.5, 2.0)
		#pick_new_target()
	#var tar = Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * speed
	#$RigidBody3D.apply_force(tar, target_position


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Play fall animation")
	pass # Replace with function body.
