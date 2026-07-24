extends Node3D

@export var vehicle: VehicleBody3D

@export var follow_distance := 8.0
@export var follow_height := 3.0
@export var follow_speed := 6.0

func _ready():
	var desired = vehicle.global_position
	desired -= vehicle.global_basis.z * follow_distance
	desired += Vector3.UP * follow_height
	
	global_position = desired
	look_at(vehicle.global_position + Vector3.UP, Vector3.UP)
	

func _physics_process(delta):

	var desired = vehicle.global_position
	desired -= vehicle.global_basis.z * follow_distance
	desired += Vector3.UP * follow_height

	global_position = global_position.lerp(
		desired,
		follow_speed * delta
	)

	look_at(vehicle.global_position + Vector3.UP, Vector3.UP)
