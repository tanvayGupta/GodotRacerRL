extends Node3D

@onready var root = get_parent()
@onready var path: Path3D = root.get_node("SpaPath")
@onready var cones_parent: Node3D = root.get_node("Cones")
@onready var rightMesh : MeshInstance3D = root.get_node("MeshParent/RightMesh")
@onready var leftMesh : MeshInstance3D = root.get_node("MeshParent/LeftMesh")
const TRACK_WIDTH := 20.0
const CONE_SPACING := 16.0
const SAMPLING_DISTANCE := 5.0
const WALL_HEIGHT := 2.0
const HALF_TRACK_WIDTH := TRACK_WIDTH/2 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Emptying the Cones Group
	for child in cones_parent.get_children():
		child.queue_free()
	
	#Flattening Path, because the points werent snapped to y=0 smh
	var curve = path.curve

	for i in range(curve.point_count):
		var p = curve.get_point_position(i)
		p.y = 0.0
		curve.set_point_position(i, p)
	match GameSettings.boundary_type:

		GameSettings.BoundaryType.CONES:
			generate_cones()

		GameSettings.BoundaryType.WALLS:
			generate_right_wall()
			generate_left_wall()

func generate_cones():
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
func generate_right_wall():
	var vertices = PackedVector3Array()
	var curve = path.curve
	var length = curve.get_baked_length()
	
	var distance = 0.0
	
	while distance < length:
		var pos = curve.sample_baked(distance)
		var next_pos = curve.sample_baked(min(distance+0.1,length))
		
		var forward = (next_pos-pos).normalized()
		var right = forward.cross(Vector3.UP).normalized()
		
		var right_barrier_bottom = pos + right * HALF_TRACK_WIDTH
		var right_barrier_top = right_barrier_bottom + Vector3.UP * WALL_HEIGHT
		var right_barrier_back = right_barrier_top + right + Vector3.UP * 0.5
		
		vertices.push_back(right_barrier_bottom)
		vertices.push_back(right_barrier_top)
		vertices.push_back(right_barrier_back)
		
		distance += SAMPLING_DISTANCE
	
	var indices = PackedInt32Array()
	var total_vertices = len(vertices)-3
	var i := 0
	var toggler = false
	for j in (total_vertices/3)*2:
		indices.push_back(i)
		indices.push_back(i+3)
		indices.push_back(i+1)
		
		i+=1
		
		indices.push_back(i)
		indices.push_back(i+2)
		indices.push_back(i+3)
		if toggler:
			i += 1
		toggler = not toggler
		
		
	
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	rightMesh.mesh = arr_mesh
func generate_left_wall():
	var vertices = PackedVector3Array()
	var curve = path.curve
	var length = curve.get_baked_length()
	
	var distance = 0.0
	
	while distance < length:
		var pos = curve.sample_baked(distance)
		var next_pos = curve.sample_baked(min(distance+0.1,length))
		
		var forward = (next_pos-pos).normalized()
		var right = forward.cross(Vector3.UP).normalized()
		
		var left_barrier_bottom = pos - right * HALF_TRACK_WIDTH
		var left_barrier_top = left_barrier_bottom + Vector3.UP * WALL_HEIGHT
		var left_barrier_back = left_barrier_top - right + Vector3.UP*0.5
		
		vertices.push_back(left_barrier_bottom)
		vertices.push_back(left_barrier_top)
		vertices.push_back(left_barrier_back)
		
		distance += SAMPLING_DISTANCE
	
	var indices = PackedInt32Array()
	var total_vertices = len(vertices)-3
	var i := 0
	var toggler = false
	for j in (total_vertices/3)*2:
		indices.push_back(i)
		indices.push_back(i+1)
		indices.push_back(i+3)
		
		i+=1
		
		indices.push_back(i)
		indices.push_back(i+3)
		indices.push_back(i+2)
		if toggler:
			i += 1
		toggler = not toggler
		
		
	
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	leftMesh.mesh = arr_mesh
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
