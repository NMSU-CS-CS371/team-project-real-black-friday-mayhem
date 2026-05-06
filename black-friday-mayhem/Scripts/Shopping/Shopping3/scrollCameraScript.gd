extends Camera2D

@export var scrollSpeed : float
@onready var sceneTransition = $"../SceneTransition/AnimationPlayer"
@onready var optionsPanel = get_tree().get_root().get_child(2).get_node("OptionsPanel")
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
		optionsPanel.position.x = position.x - 275
	#print(position)
