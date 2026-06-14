extends VehicleBody3D

# --- Tunable parameters ---
var max_engine_force = 3500.0
var max_steering_angle = 0.7
var steering_per_unit = 0.05
var brake_force = 50.0
var steer = 0.0

# Grip tuning
var lateral_grip_strength = 8.0

func _physics_process(delta):
	# --- INPUT ---
	var engine = 0.0
	var braking = 0.0
	#print("running car")

	if Input.is_action_pressed("accelerate"):
		#print(steer)
		engine = max_engine_force

	if Input.is_action_pressed("brake"):
		braking = brake_force

	if Input.is_action_pressed("steer_left"):
		if steer < max_steering_angle:
			steer += steering_per_unit
		#print(steer)

	if Input.is_action_pressed("steer_right"):
		if steer > -max_steering_angle:
			steer -= steering_per_unit
		#print(steer)
	
	if Input.is_action_pressed("reverse"):
		engine = -max_engine_force
	
	# --- APPLY TO VEHICLE ---
	engine_force = engine
	steering = steer
	brake = braking

	# --- ARCADE GRIP SYSTEM (IMPORTANT PART) ---
	#apply_lateral_grip(delta)
	
func apply_lateral_grip(delta):
	var velocity = linear_velocity

	# Get car forward direction (Z axis)
	var forward = transform.basis.z.normalized()

	# Project velocity onto forward direction
	var forward_velocity = forward * velocity.dot(forward)

	# Lateral (sideways) velocity = what's left
	var lateral_velocity = velocity - forward_velocity

	# Reduce sideways sliding
	var corrected_velocity = velocity - lateral_velocity * lateral_grip_strength * delta

	linear_velocity = corrected_velocity
