extends Camera2D

@export var scrollSpeed : float
@onready var sceneTransition = $"../SceneTransition/AnimationPlayer"
#var firstPosition : Vector3
var scrollAllowed: bool = false

func _ready() -> void:
	make_current()
	await sceneTransition.animation_finished
	scrollAllowed = true
	#var camera = get_parent().get_parent().get_parent().get_parent().mainCamera
	pass

func _process(delta: float) -> void:
	if scrollAllowed:
		position.x += scrollSpeed * delta
	#print(position)
