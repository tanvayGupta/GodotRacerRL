@tool
extends Path3D

@export var bake_scale_factor: float = 0.3  # your scale-down factor
@export var apply_now: bool = false:
	set(value):
		if value:
			_bake_scale()

func _bake_scale() -> void:
	var c := curve
	if c == null:
		return

	for i in range(c.get_point_count()):
		var pos = c.get_point_position(i)
		var in_ctrl = c.get_point_in(i)
		var out_ctrl = c.get_point_out(i)

		c.set_point_position(i, pos * bake_scale_factor)
		c.set_point_in(i, in_ctrl * bake_scale_factor)
		c.set_point_out(i, out_ctrl * bake_scale_factor)

	# reset the node's own scale since it's now baked into the curve
	scale = Vector3.ONE
	print("Baked curve scale by ", bake_scale_factor, ". Path3D scale reset to 1.")
