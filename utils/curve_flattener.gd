@tool
extends EditorScript

func _run():
	var path = get_scene().get_node("SpaPath") # change if needed
	var curve = path.curve

	for i in range(curve.point_count):
		var p = curve.get_point_position(i)
		p.y = 0.0
		curve.set_point_position(i, p)

	print("Curve flattened.")
