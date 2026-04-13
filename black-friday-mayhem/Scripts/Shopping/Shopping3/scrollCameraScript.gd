extends Camera2D

@export var scrollSpeed : float
#var firstPosition : Vector3

func _ready() -> void:
	make_current()
	#var camera = get_parent().get_parent().get_parent().get_parent().mainCamera
	pass

func _process(delta: float) -> void:
	position.x += scrollSpeed * delta
	#print(position)
