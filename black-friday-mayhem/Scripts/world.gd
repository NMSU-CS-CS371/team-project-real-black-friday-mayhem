extends Node

@onready var SceneTransition = $ShopCheckpoint/SceneTransition/AnimationPlayer

func _ready() -> void:
	SceneTransition.get_parent().get_node("ColorRect").color.a = 255
	SceneTransition.play("fade_out")
