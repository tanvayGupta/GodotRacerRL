extends Node3D

@export var target: VehicleBody3D
@export var follow_speed := 5.0
@export var look_speed := 5.0

func _physics_process(delta):
	if target == null:
		print("NO TARGET")
		return

	# --- FOLLOW POSITION ---
	var target_pos = target.global_transform.origin
	global_transform.origin = global_transform.origin.lerp(target_pos, follow_speed * delta)

	# --- LOOK DIRECTION ---
	var forward = target.global_transform.basis.z
	var look_at_pos = target_pos + forward * 5.0

	look_at(look_at_pos, Vector3.UP)
