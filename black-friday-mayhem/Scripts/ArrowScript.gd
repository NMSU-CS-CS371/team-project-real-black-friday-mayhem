extends MeshInstance3D

@export var location : Vector3

func _process(delta: float) -> void:
	# I kept getting lost
	look_at(location)
	rotation.x = 0
	rotation.z = 0
	
	pass
