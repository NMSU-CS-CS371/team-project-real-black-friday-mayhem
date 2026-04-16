extends MeshInstance3D

var focus : Node3D

func _process(_delta: float) -> void:
	if focus != null:
		look_at(focus.position)
	else:
		look_at(Vector3.ZERO)
	# I kept getting lost
	rotation.x = 0
	rotation.z = 0
	
	pass
