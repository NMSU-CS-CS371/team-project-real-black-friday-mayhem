extends Camera3D

@export var playerCamera : Node3D

#Anything in layer 6 will be displayed over the main game

func _process(_delta: float) -> void:
	position = playerCamera.global_position
	rotation = playerCamera.global_rotation
