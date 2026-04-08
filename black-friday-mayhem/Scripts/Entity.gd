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

# Texture (albedo) for the entity - works in both 2D and 3D modes
@export var texture: Texture2D:
	set(value):
		texture = value
		if is_node_ready():
			_update_visuals()

# General Properties
@export var entity_name: String = "Entity"

# Interaction System
# Emitted when the player interacts with or enters the trigger of this entity
signal player_entered

# Toggles whether the entity is currently interactive
# Subclasses should override _update_interactable() to handle the actual logic (e.g., disabling collision)
@export var is_interactable: bool = true:
	set(value):
		is_interactable = value
		if is_node_ready():
			_update_interactable()

func _ready() -> void:
	_update_visuals()
	_update_interactable()

func _update_visuals() -> void:
	# This function acts as a hook for subclasses to update their visuals
	if has_method("_apply_size"):
		call("_apply_size")
	if has_method("_apply_color"):
		call("_apply_color")

func _update_interactable() -> void:
	# Virtual method for subclasses to implement interaction toggling
	pass
