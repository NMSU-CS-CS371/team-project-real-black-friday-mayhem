@tool
extends EditorScript

const MIN_SIZE := 0.01

func _run():
	print("START ")
	var root = get_editor_interface().get_edited_scene_root()

	if root == null:
		print("No scene open.")
		return

	scan(root)

func scan(node):

	if node is MeshInstance3D:

		if node.gi_mode == GeometryInstance3D.GI_MODE_STATIC:

			var mesh = node.mesh

			if mesh:

				var aabb = mesh.get_aabb()
				var size = aabb.size

				var suspicious := false
				
				if node.gi_lightmap_scale == 0:
					suspicious = true
				
				# Tiny dimensions
				if size.x < MIN_SIZE:
					suspicious = true

				if size.y < MIN_SIZE:
					suspicious = true

				if size.z < MIN_SIZE:
					suspicious = true

				# Invalid dimensions
				if is_nan(size.x) or is_nan(size.y) or is_nan(size.z):
					suspicious = true

				if suspicious:
					print("")
					print("Suspicious mesh:")
					print(node.get_path())
					print("AABB Size: ", size)
					print("Scale: ", node.global_transform.basis.get_scale())
					print("GI Lightmap Scale: ", node.gi_lightmap_scale)
					#node.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	for child in node.get_children(true):
		scan(child)
