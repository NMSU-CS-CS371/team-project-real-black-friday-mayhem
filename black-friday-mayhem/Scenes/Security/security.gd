extends Node3D

@export var dialogue_scene: CanvasLayer

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	print("BODY HIT: ", body.name)
	dialogue_scene.show_dialogue()

func _on_area_entered(area):
	print("AREA HIT: ", area.name)
	dialogue_scene.show_dialogue()
