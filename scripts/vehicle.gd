extends VehicleBody3D

@onready var ai_controller = $AIController3D
@onready var sensor_rig = %SensorRig

const MAP_SCENES := {
	GameSettings.MapName.SPA: "res://scenes/tracks/spa_track.tscn",
	GameSettings.MapName.INK: "res://scenes/tracks/ink_track.tscn",
}


var max_engine_force = 1800.0
var max_steering_angle := 0.5
var steering_per_unit := 0.1
var brake_force := 100.0
var steer := 0.0
var leftRight = Input.get_axis("steer_left","steer_right")
var secondCounter := 0.0
var speed = 0.0
var engine = 0.0
var braking = 0.0

var spawn_position: Vector3
var spawn_rotation: Vector3

var lateral_grip_strength = 25.0

var humanMode = PlayerSettings.humanMode

func _ready():
	spawn_position = global_position
	spawn_rotation = rotation
	
	contact_monitor = true
	#continuous_cd = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	
	if not humanMode:
		ai_controller.init(self)
		GameEvents.checkpointPassed.connect(_on_checkpoint_passed)
		GameEvents.checkpointPenalty.connect(_on_checkpoint_violation)
		
	GameEvents.wall_hit.connect(_on_wall_hit)
		
func _physics_process(delta):
#	 or abs(global_position.x) > (960) or abs(global_position.z) > 540
	if humanMode:
		engine = 0.0
		braking = 0.0
		if Input.is_action_just_pressed("reset"):
			reset_car()
			GameSettings.penalty = 0
			get_tree().reload_current_scene()
		
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
			
		#Counts half a second
		if secondCounter > 0.5:
			secondCounter = 0.0
			speed = linear_velocity.length() * 3 
			GameSettings.speed = speed
			GameSettings.angle = steer	
	
	elif not humanMode:
		#PlayerSettings.speed = linear_velocity.length()/100waadw
		if ai_controller.needs_reset:
			print("stuck in reset loop")
			ai_controller.reset()
			reset_car()
			return
		
		if 	secondCounter > 0.9:
			secondCounter = 0.0
			ai_controller.reward -= 0.1
		
		if global_transform.basis.y.dot(Vector3.UP) < 0.2:
			ai_controller.reward -= 5.0
			ai_controller.done = true
			ai_controller.needs_reset = true
			
			
	secondCounter += delta
			
	engine_force = engine
	steering = steer
	brake = braking
	#if not humanMode:
		#print("engine:", engine, " steer:", steer, " brake:", braking)
	
func _on_checkpoint_passed(vehicle: VehicleBody3D) -> void:
	if vehicle != self or humanMode:
		return
	ai_controller.reward += 8.0
	
func _on_checkpoint_violation(_penalty: int, vehicle: VehicleBody3D):
	if vehicle != self or humanMode:
		return
	ai_controller.reward -= 3.0
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Walls"):
		GameEvents.wall_hit.emit(self)
		
func _on_wall_hit(vehicle: VehicleBody3D) -> void:
	if vehicle != self:
		return
	if humanMode:
		GameSettings.penalty += 1
		return
	ai_controller.reward -= 3
	ai_controller.done = true
	ai_controller.needs_reset = true

func reset_car():
	global_position = spawn_position
	rotation = spawn_rotation

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO


func applyAction(steer_cmd: float, throttle_cmd: float, brake_cmd: float):
	steer = clamp(steer_cmd, -1.0, 1.0) * max_steering_angle
	engine = clamp(throttle_cmd, -1.0, 1.0) * max_engine_force
	braking = clamp(brake_cmd, 0.0, 1.0) * brake_force
	
