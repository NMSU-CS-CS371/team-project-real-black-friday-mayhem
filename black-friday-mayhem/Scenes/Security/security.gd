extends Node3D

@export var dialogue_scene = preload("res://Scenes/Security/tutorial.tscn")

#func _ready():
	#$Area3D.body_entered.connect(_on_body_entered)
	#$Area3D.area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	AudioManager.pause_main_music()
	var tutorial = dialogue_scene.instantiate()
	add_child(tutorial)
