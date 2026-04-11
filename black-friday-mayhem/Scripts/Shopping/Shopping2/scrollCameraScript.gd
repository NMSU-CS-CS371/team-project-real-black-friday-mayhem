extends Camera2D

@export var scrollSpeed : float

func _process(delta: float) -> void:
	position.x += scrollSpeed * delta
