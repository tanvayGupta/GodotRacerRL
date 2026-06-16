extends VehicleBody3D

#Label
@onready var speed_label = get_node("/root/Game/CanvasLayer/Panel/VBoxContainer/SpeedLabel")

# --- Tunable parameters ---
var max_engine_force = 25000.0
var max_steering_angle := 0.6
var steering_per_unit := 0.15
var brake_force := 300.0
var steer := 0.0
var leftRight = Input.get_axis("steer_left","steer_right")
var secondCounter := 0.0
var speed = 0.0

#Intitial position
var spawn_position: Vector3
var spawn_rotation: Vector3

# Grip tuning
var lateral_grip_strength = 25.0

func _ready():
	spawn_position = global_position
	spawn_rotation = rotation
		
		
func _physics_process(delta):
	# --- INPUT ---
	var engine = 0.0
	var braking = 0.0
	
	if Input.is_action_just_pressed("reset") or abs(global_position.x) > (960) or abs(global_position.z) > 540:
		reset_car()
	
	if Input.is_action_pressed("accelerate"):
		#print(steer)
		engine = max_engine_force

	if Input.is_action_pressed("brake"):
		braking = brake_force

	if Input.is_action_pressed("steer_left"):
		steer = move_toward(steer, max_steering_angle, steering_per_unit)
		#print(steer)

	if Input.is_action_pressed("steer_right"):
		steer = move_toward(steer, -max_steering_angle, steering_per_unit)
		#print(steer)
		
	if leftRight == 0:
		steer /= 1.3
	
	if Input.is_action_pressed("reverse"):
		engine = -max_engine_force
		
	secondCounter += delta
	#Counts half a second
	if secondCounter > 0.5:
		secondCounter = 0.0
		speed = linear_velocity.length() * 3.6
		speed_label.text = "Speed :\n %.1f kmph" % speed
		
	
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
	
func reset_car():
	global_position = spawn_position
	rotation = spawn_rotation

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
