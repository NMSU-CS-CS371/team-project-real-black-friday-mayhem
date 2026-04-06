extends Node2D

@onready var sceneTransition = $SceneTransition/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# finish scene transition
	sceneTransition.get_parent().get_node("ColorRect").color.a = 255
	sceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed():
	# begin scene transition
	sceneTransition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_options_pressed():
	print("options pressed")
