extends VehicleBody3D


#@onready var speed_label = %SpeedLabel
#@onready var steer_label = %VSeperator

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

var spawn_position: Vector3
var spawn_rotation: Vector3

var lateral_grip_strength = 25.0

func _ready():
	spawn_position = global_position
	spawn_rotation = rotation
		
		
func _physics_process(delta):
	var engine = 0.0
	var braking = 0.0
#	 or abs(global_position.x) > (960) or abs(global_position.z) > 540
	if Input.is_action_just_pressed("reset"):
		reset_car()
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
		
	secondCounter += delta
	#Counts half a second
	if secondCounter > 0.5:
		secondCounter = 0.0
		speed = linear_velocity.length() * 5
		#speed_label.text = "Speed :\n %.1f kmph" % speed
		#steer_label.text = "Steer :\n %.2f rads" % steer
		
	
	engine_force = engine
	steering = steer
	brake = braking


	

func reset_car():
	global_position = spawn_position
	rotation = spawn_rotation

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
