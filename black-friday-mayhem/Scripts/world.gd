extends Node

class_name World

@onready var SceneTransition = $SceneTransition/AnimationPlayer

func _ready() -> void:
	SceneTransition.get_parent().get_node("ColorRect").color.a = 255
	SceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	SceneTransition.get_parent().get_node("ColorRect").visible = false
