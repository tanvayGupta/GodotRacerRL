@tool
extends EditorScript

const TRACK_WIDTH := 20.0
const SAMPLING_DISTANCE := 5.0
const WALL_HEIGHT := 2.0
const HALF_TRACK_WIDTH := TRACK_WIDTH/2  #It's possible to do this lmao

func _run():
	var root = get_editor_interface().get_edited_scene_root() #Basically the same thing as get_scene() but sicne its deprecated
	
	var path : Path3D = root.get_node("SpaPath")
	var rightMesh : MeshInstance3D = root.get_node("MeshParent/LeftMesh")
	
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
	rightMesh.mesh = arr_mesh
	
