extends Node3D

@export var max_distance := 20.0
#@onready var sensorRig = %SensorRig
@export var ray_count := 30

func _ready() -> void:
	#for raycast in sensorRig.get_children():
		#raycast.collide_with_bodies = false
		#raycast.collide_with_areas = false
		#
		#raycast.set_collision_mask(1)
		#raycast.set_collision_mask(2)
		
	for i in ray_count:
		var ray := RayCast3D.new()
		
		ray.collide_with_areas = true
		ray.collide_with_bodies = true
		ray.set_collision_mask_value(2,true)
		
		var angle = lerp(-PI/3, PI/3, float(i)/(ray_count-1))
		
		ray.target_position = Vector3(
			sin(angle) * max_distance,
			0,
			-cos(angle) * max_distance
		)
		ray.enabled = true
		add_child(ray)
		

func get_observation() -> PackedFloat32Array:
	var obs := PackedFloat32Array()
	for ray in get_children():
		if ray is RayCast3D:
			if ray.is_colliding():
				var d = global_position.distance_to(ray.get_collision_point())
				#print(d)
				obs.append(d / max_distance)
				#obs.append(d)a
			else:
				obs.append(max_distance/max_distance)
	return obs
	
func _physics_process(_delta: float) -> void:
	get_observation()
	#print(get_observation())
