@tool
extends EditorScript

func _run():
	print("START ")
	var root = get_editor_interface().get_edited_scene_root()

	if root == null:
		print("No scene open.")
		return

	scan_recursive(root)

func scan_recursive(node):

	# Debug traversal if needed
	# print(node.get_path())
	#print(node.get_class(), " : ", node.get_path())

	if node is MeshInstance3D:

		if node.gi_mode == GeometryInstance3D.GI_MODE_STATIC:

			var mesh = node.mesh

			if mesh:

				var missing_uv2 = false

				for s in range(mesh.get_surface_count()):

					var arrays = mesh.surface_get_arrays(s)
					var uv2 = arrays[Mesh.ARRAY_TEX_UV2]

					if uv2 == null or uv2.size() == 0:
						missing_uv2 = true
						break

				if missing_uv2:
					print(" ")
					print("Missing UV2: ", node.get_path())

	# IMPORTANT:
	# true = include internal children
	for child in node.get_children(true):
		scan_recursive(child)
