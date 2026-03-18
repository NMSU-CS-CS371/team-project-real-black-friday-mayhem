extends Timer

func _ready() -> void:
	start()

#example of changing scenes from 2D to 3D
#Will change the scene (automatically, check the autostart settings in the timer) after 5 seconds
func _on_timeout() -> void:
	print("changed scene")
	get_tree().change_scene_to_file("res://sample_scene.tscn")
	pass # Replace with function body.
