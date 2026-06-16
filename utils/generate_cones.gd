@tool
extends EditorScript

const TRACK_WIDTH := 20.0
const CONE_SPACING := 16.0

func _run():

	var root = get_scene()

	var path: Path3D = root.get_node("SpaPath")
	var cones_parent: Node3D = root.get_node("Cones")

	# Remove old cones
	for child in cones_parent.get_children():
		child.queue_free()

	var yellow_cone_scene = load("res://screens/yellow_cone.tscn")
	var blue_cone_scene = load("res://screens/blue_cone.tscn")

	var curve = path.curve
	var length = curve.get_baked_length()

	var distance = 0.0

	while distance < length:

		var pos = curve.sample_baked(distance)

		var next_pos = curve.sample_baked(
			min(distance + 0.1, length)
		)

		var forward = (next_pos - pos).normalized()

		var right = forward.cross(Vector3.UP).normalized()

		var half_width = TRACK_WIDTH * 0.5

		var left_pos = pos - (right * half_width)
		var right_pos = pos + (right * half_width)

		var left_cone = yellow_cone_scene.instantiate()
		left_cone.position = left_pos
		cones_parent.add_child(left_cone)
		left_cone.owner = root

		var right_cone = blue_cone_scene.instantiate()
		right_cone.position = right_pos
		cones_parent.add_child(right_cone)
		right_cone.owner = root

		distance += CONE_SPACING

	print("Generated cones.")
