@tool
extends Entity

# The size of the obstacle in 3D space (width, height, depth)
# Changing this in the Inspector will automatically update collision, mesh, and trigger zone
@export var obstacle_size: Vector3 = Vector3(1.0, 1.0, 1.0):
	set(value):
		obstacle_size = value
		_apply_size()

# The placeholder color of the obstacle mesh
# Useful for visually distinguishing obstacle types before real textures are added
@export var obstacle_color: Color = Color(0.8, 0.8, 0.8):
	set(value):
		obstacle_color = value
		_apply_color()

func _ready() -> void:
	# Call super _ready() to handle mesh initialization and interaction state
	super._ready()
	# Apply initial size and color when the scene loads
	_apply_size()
	_apply_color()
	
	# Connect the TriggerZone's body_entered signal to our handler (runtime only)
	if not Engine.is_editor_hint():
		if has_node("TriggerZone"):
			$TriggerZone.body_entered.connect(_on_trigger_zone_body_entered)

# Updates the interactable state (enabling/disabling the trigger zone)
# Overrides Entity._update_interactable()
func _update_interactable() -> void:
	if not is_node_ready():
		return
	
	if has_node("TriggerZone"):
		$TriggerZone.monitoring = is_interactable
		$TriggerZone.monitorable = is_interactable

# Updates the collision shape, mesh, and trigger zone to match obstacle_size
func _apply_size() -> void:
	# Guard: node children may not be ready yet during early initialization
	if not is_node_ready():
		return
	
	# Calculate the actual size for collision based on mesh or obstacle_size
	var actual_size := obstacle_size
	var collision_offset := Vector3.ZERO
	
	# Update the visible mesh to match based on visual_mode
	if has_node("MeshInstance3D"):
		# If a custom mesh is set on the Entity, use it and scale the node
		if mesh != null:
			$MeshInstance3D.mesh = mesh
			# Get the mesh's bounding box and scale collision to match
			var aabb := mesh.get_aabb()
			actual_size = aabb.size * obstacle_size
			# Calculate offset to center collision on the mesh
			# AABB position is the min corner, so center = position + size/2
			collision_offset = (aabb.position + aabb.size / 2.0) * obstacle_size
			# Scale the MeshInstance3D to match obstacle_size
			$MeshInstance3D.scale = obstacle_size
		elif visual_mode == "2D Sprite":
			# Create a QuadMesh for 2D mode
			var quad := QuadMesh.new()
			quad.size = Vector2(obstacle_size.x, obstacle_size.y)
			$MeshInstance3D.mesh = quad
			$MeshInstance3D.scale = Vector3.ONE
		else:
			# Create a BoxMesh for 3D mode
			var mesh_box := BoxMesh.new()
			mesh_box.size = obstacle_size
			$MeshInstance3D.mesh = mesh_box
			$MeshInstance3D.scale = Vector3.ONE
	
	# Update the solid collision shape using actual_size
	var box := BoxShape3D.new()
	box.size = actual_size
	
	if has_node("StaticBody3D/CollisionShape3D"):
		$StaticBody3D/CollisionShape3D.shape = box
		$StaticBody3D/CollisionShape3D.position = collision_offset
	elif has_node("CollisionShape3D"):
		$CollisionShape3D.shape = box
		$CollisionShape3D.position = collision_offset
	
	# Update trigger zone collision
	var trigger_box := BoxShape3D.new()
	trigger_box.size = actual_size
	if has_node("TriggerZone/CollisionShape3D"):
		$TriggerZone/CollisionShape3D.shape = trigger_box
		$TriggerZone/CollisionShape3D.position = collision_offset

# Creates and applies a plain colored material to the obstacle mesh
func _apply_color() -> void:
	# Guard: node children may not be ready yet during early initialization
	if not is_node_ready():
		return
	var mat := StandardMaterial3D.new()
	mat.albedo_color = obstacle_color
	
	# Apply texture as albedo if set
	if texture:
		mat.albedo_texture = texture
	
	# Additional settings for 2D Sprite mode
	if visual_mode == "2D Sprite":
		mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	
	if has_node("MeshInstance3D"):
		$MeshInstance3D.set_surface_override_material(0, mat)

# Fires the player_entered signal when a body enters the trigger zone
# Only responds to nodes in the "player" group to avoid false triggers
func _on_trigger_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_entered.emit()
