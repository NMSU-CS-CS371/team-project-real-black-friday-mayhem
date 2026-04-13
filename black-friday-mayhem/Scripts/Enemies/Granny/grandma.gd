extends Node3D

var anger = 0
var punchies = preload("res://Scenes/Enemies/Grandma/punchies.tscn")


func _on_hit_box_body_entered(body: Node3D) -> void:
	if anger >= 2:
		print("oh heck no")
		body.stop_velocity.emit()
		var killer_instinct = punchies.instantiate()
		add_child(killer_instinct)
		pass
	else:
		anger = anger + 1
		print("sorry.!")
		pass
	pass # Replace with function body.
