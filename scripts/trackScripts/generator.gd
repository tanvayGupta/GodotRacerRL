extends Node3D

@onready var root = get_parent()
@onready var path: Path3D = root.get_node("SpaPath")
@onready var cones_parent: Node3D = root.get_node("Cones")
@onready var rightMesh : MeshInstance3D = root.get_node("MeshParent/RightMesh")
@onready var leftMesh : MeshInstance3D = root.get_node("MeshParent/LeftMesh")
@onready var planeMesh : MeshInstance3D = root.get_node("Ground/PlaneMesh")
@onready var contour : CollisionShape3D = root.get_node("Ground/CollisionShape3D")
const TRACK_WIDTH := 20.0
const CONE_SPACING := 16.0
const SAMPLING_DISTANCE := 3.0
const WALL_HEIGHT := 10.0
const HALF_TRACK_WIDTH := TRACK_WIDTH/2 
const CONTOUR_SCALE := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Emptying the Cones Group
	for child in cones_parent.get_children():
		child.queue_free()
	
	#Flattening Path, because the points werent snapped to y=0 smh
	#var curve = path.curve
	#for i in range(curve.point_count):
		#var p = curve.get_point_position(i)
		#p.y = 0.0
		#curve.set_point_position(i, p)
		
	generate_contour_track()
	match GameSettings.boundary_type:

		GameSettings.BoundaryType.CONES:
			generate_cones()

		GameSettings.BoundaryType.WALLS:
			generate_right_wall()
			generate_left_wall()	

#func generate_contour_full():
	#var noise = FastNoiseLite.new()
	#var contour = PackedVector3Array()
	##var v = Vector3()
	#var y = 0
	#noise.frequency = 0.005
	#noise.seed = 67
	##Xgoes from -960 to +960
	##Z goes from -540 to +540
	#
	#for x in range(-960,960, 1):
		#for z in range(-540, 540, 1):
			#
			#y = noise.get_noise_2d(x,z)
			#contour.push_back(Vector3(x,y,z))
	
	
	
	
func generate_cones():
	var yellow_cone_scene = load("res://screens/yellow_cone.tscn")
	var blue_cone_scene = load("res://screens/blue_cone.tscn")

	var vertices = track_boundary_point(false)
	var total_vertices = len(vertices)
	
	for i in total_vertices/2:
		var left_cone = yellow_cone_scene.instantiate()
		left_cone.position = vertices[2*i]
		cones_parent.add_child(left_cone)
		left_cone.owner = root

		var right_cone = blue_cone_scene.instantiate()
		right_cone.position = vertices[2*i+1]
		cones_parent.add_child(right_cone)
		right_cone.owner = root

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
	
	generate_mesh(arr_mesh)
	
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
	generate_mesh(arr_mesh)
	
func generate_mesh(arr_mesh: ArrayMesh):
	var body = StaticBody3D.new()
	body.name = "WallCollision"
	
	body.collision_layer = 2
	body.collision_mask = 1
	
	var shape = CollisionShape3D.new()
	shape.shape = arr_mesh.create_trimesh_shape()
	
	body.add_child(shape)
	rightMesh.add_child(body)

func track_boundary_point(contour = false):
	var sampling = SAMPLING_DISTANCE if contour else CONE_SPACING
	var vertices = PackedVector3Array()
	var curve = path.curve
	var length = curve.get_baked_length()
	var distance = 0.0
	var y = 0.0
	var noise = FastNoiseLite.new()
	noise.frequency = 0.003
	noise.seed = 67
	var extra = 2 if contour else 0
	
	while distance < length:

		var pos = curve.sample_baked(distance, false)

		var next_pos = curve.sample_baked(
			min(distance + 0.1, length),
			false
		)

		var forward = (next_pos - pos).normalized()

		var right = forward.cross(Vector3.UP).normalized()

		var half_width = TRACK_WIDTH * 0.5 + extra

		var left_pos = pos - (right * half_width)
		var right_pos = pos + (right * half_width)
		
		#if contour:
			
		y = noise.get_noise_2d(left_pos.x,left_pos.z) * CONTOUR_SCALE
		left_pos.y = y
		y = noise.get_noise_2d(right_pos.x,right_pos.z) * CONTOUR_SCALE
		right_pos.y = y
		
		vertices.push_back(left_pos)
		vertices.push_back(right_pos)
		
		distance += sampling
	
	return vertices

func generate_contour_track():
	var vertices = track_boundary_point(true)  
	var total_vertices = len(vertices)
	print(total_vertices)
	var rasterization = PackedVector3Array()
	
	for i in (total_vertices/2)-1:
		rasterization.push_back(vertices[2*i])
		rasterization.push_back(vertices[2*i+3])
		rasterization.push_back(vertices[2*i+1])
		
		rasterization.push_back(vertices[2*i])
		rasterization.push_back(vertices[2*i+2])
		rasterization.push_back(vertices[2*i+3])
	
	#Loop Closing Triangles
	rasterization.push_back(vertices[0])
	rasterization.push_back(vertices[total_vertices-1])
	rasterization.push_back(vertices[total_vertices-2])
	
	rasterization.push_back(vertices[0])
	rasterization.push_back(vertices[1])
	rasterization.push_back(vertices[total_vertices-1])
		
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	print("Rasterization Vertices:", rasterization.size())
	
	arrays[Mesh.ARRAY_VERTEX] = rasterization
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	planeMesh.mesh = mesh
	print("Mesh faces:", mesh.get_faces().size())
	
	var shape = ConcavePolygonShape3D.new()
	shape.set_faces(rasterization)
	contour.shape = shape
	print(contour.shape)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
