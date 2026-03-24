@tool
class_name Entity
extends Node3D

# Visual Configuration
@export_enum("3D Mesh", "2D Sprite") var visual_mode: String = "2D Sprite":
	set(value):
		visual_mode = value
		if is_node_ready():
			_update_visuals()

# 3D Properties
@export var mesh: Mesh:
	set(value):
		mesh = value
		if is_node_ready():
			_update_visuals()
@export_enum("Static", "Dynamic", "Character") var mesh_type: String = "Static"

# 2D Properties
@export var sprite_texture: Texture2D:
	set(value):
		sprite_texture = value
		if is_node_ready():
			_update_visuals()

# General Properties
@export var behavior_script: Script
@export var entity_name: String = "Entity"

func _ready() -> void:
	_update_visuals()

func _update_visuals() -> void:
	# This function acts as a hook for subclasses to update their visuals
	if has_method("_apply_size"):
		call("_apply_size")
	if has_method("_apply_color"):
		call("_apply_color")
