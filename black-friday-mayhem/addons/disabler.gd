@tool
extends EditorScript

func _run():
	var root = get_editor_interface().get_edited_scene_root()
	disable_static(root)

func disable_static(node):

	if node is MeshInstance3D:
		node.gi_mode = GeometryInstance3D.GI_MODE_DISABLED

	for child in node.get_children():
		disable_static(child)
