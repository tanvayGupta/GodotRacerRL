extends Node3D

@onready var root = get_parent()
@onready var path: Path3D = root.get_node("Ground/TrackPath")
@onready var cones_parent: Node3D = root.get_node("Cones")
@onready var rightMesh : MeshInstance3D = root.get_node("MeshParent/RightMesh")
@onready var leftMesh : MeshInstance3D = root.get_node("MeshParent/LeftMesh")


var TRACK_WIDTH := 20.0
var CONE_SPACING := 16.0
var WALL_HEIGHT := 2.0
var HALF_TRACK_WIDTH := 10.0
var WALL_THICKNESS := 2.0

const SAMPLING_DISTANCE := 4.0

const MAP_CONFIGS := {
	GameSettings.MapName.SPA: {
		"track_width": 20.0,
		"cone_spacing": 16.0,
		"wall_height": 2.0,
		"wall_thickness": 0.5,
	},
	GameSettings.MapName.INK: {
		"track_width": 20.0,
		"cone_spacing": 10.0,
		"wall_height": 3.0,
		"wall_thickness": 1.5,
	},
	"monza": {
		"track_width": 24.0,
		"cone_spacing": 20.0,
		"wall_height": 1.5,
		"wall_thickness": 0.4,
	},
}

func _apply_map_settings() -> void:
	var key = GameSettings.map_name
	var config = MAP_CONFIGS.get(key, MAP_CONFIGS[GameSettings.MapName.INK])

	TRACK_WIDTH = config["track_width"]
	CONE_SPACING = config["cone_spacing"]
	WALL_HEIGHT = config["wall_height"]
	WALL_THICKNESS = config["wall_thickness"]
	HALF_TRACK_WIDTH = TRACK_WIDTH / 2.0

func _ready() -> void:
	_apply_map_settings()

	for child in cones_parent.get_children():
		child.queue_free()

	var curve = path.curve
	for i in range(curve.point_count):
		var p = curve.get_point_position(i)
		p.y = 0.0
		curve.set_point_position(i, p)

	match GameSettings.boundary_type:
		GameSettings.BoundaryType.CONES:
			generate_cones()
		GameSettings.BoundaryType.WALLS:
			generate_wall(1.0, rightMesh)
			generate_wall(-1.0, leftMesh)

func generate_cones():
	var yellow_cone_scene = load("res://scenes/yellow_cone.tscn")
	var blue_cone_scene = load("res://scenes/blue_cone.tscn")

	var curve = path.curve
	var length = curve.get_baked_length()
	var distance = 0.0

	while distance < length:
		var pos = curve.sample_baked(distance)
		var next_pos = curve.sample_baked(min(distance + 0.1, length))
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

# Adds two triangles (a,b,c) and (a,c,d). Pass corners in CCW order
# as seen from the side the face should be visible from.
func _add_quad(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3) -> void:
	var normal = (b - a).cross(d - a).normalized()

	st.set_normal(normal)
	st.add_vertex(a)
	st.set_normal(normal)
	st.add_vertex(b)
	st.set_normal(normal)
	st.add_vertex(c)

	st.set_normal(normal)
	st.add_vertex(a)
	st.set_normal(normal)
	st.add_vertex(c)
	st.set_normal(normal)
	st.add_vertex(d)

# side_sign: 1.0 for the right wall, -1.0 for the left wall.
func generate_wall(side_sign: float, mesh_instance: MeshInstance3D) -> void:
	var curve = path.curve
	var length = curve.get_baked_length()

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var distance = 0.0
	var has_prev = false
	var prev_inner_bottom := Vector3.ZERO
	var prev_inner_top := Vector3.ZERO
	var prev_outer_bottom := Vector3.ZERO
	var prev_outer_top := Vector3.ZERO

	while distance < length:
		var pos = curve.sample_baked(distance)
		var next_pos = curve.sample_baked(min(distance + 0.1, length))
		var forward = (next_pos - pos).normalized()
		var right = forward.cross(Vector3.UP).normalized()

		var inner_bottom = pos + right * side_sign * HALF_TRACK_WIDTH
		var inner_top = inner_bottom + Vector3.UP * WALL_HEIGHT
		var outer_bottom = inner_bottom + right * side_sign * WALL_THICKNESS
		var outer_top = inner_top + right * side_sign * WALL_THICKNESS
		
		#debugging spa, wehatewalls 
		if forward.length() < 0.001:
			print("Zero forward vector at distance: ", distance)
		
		if has_prev:
			if side_sign > 0.0:
				_add_quad(st, prev_inner_top, prev_inner_bottom, inner_bottom, inner_top)   # inner face
				_add_quad(st, prev_outer_bottom, prev_outer_top, outer_top, outer_bottom)   # outer face
				_add_quad(st, prev_inner_top, inner_top, outer_top, prev_outer_top)          # top cap
			else:
				_add_quad(st, prev_inner_bottom, prev_inner_top, inner_top, inner_bottom)   # inner face
				_add_quad(st, prev_outer_top, prev_outer_bottom, outer_bottom, outer_top)   # outer face
				_add_quad(st, inner_top, prev_inner_top, prev_outer_top, outer_top)          # top cap

		prev_inner_bottom = inner_bottom
		prev_inner_top = inner_top
		prev_outer_bottom = outer_bottom
		prev_outer_top = outer_top
		has_prev = true

		distance += SAMPLING_DISTANCE

	st.index()
	var arr_mesh = st.commit()
	mesh_instance.mesh = arr_mesh

	generate_mesh_collision(arr_mesh, mesh_instance)

func generate_mesh_collision(arr_mesh: ArrayMesh, mesh_instance: MeshInstance3D) -> void:
	var body = StaticBody3D.new()
	body.name = "WallCollision"
	body.collision_layer = 2
	body.collision_mask = 1

	var shape = CollisionShape3D.new()
	shape.shape = arr_mesh.create_trimesh_shape()

	body.add_child(shape)
	mesh_instance.add_child(body)  # fixed: was always rightMesh before

func _process(_delta: float) -> void:
	pass
