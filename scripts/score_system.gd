extends Node3D

@onready var LapLabel = %LapLabel
@onready var TimeLabel = %TimeLabel
@onready var PenaltyLabel = %PenaltyLabel
@onready var LapTimeLabel = %LapTimeLabel
@onready var SpeedLabel = %SpeedLabel
@onready var AngleLabel = %AngleLabel
@onready var track_container: Node3D = %TrackContainer

#var score = 0.0
var time_elapsed := 0.0
var accumulator := 0.0
var secondAccu := 0.0
var last_lap := 0.0
var current_lap: int = 1

const MAP_SCENES := {
	GameSettings.MapName.SPA: preload("res://scenes/spa_path.tscn"),
	GameSettings.MapName.INK: preload("res://scenes/agent_path.tscn"),
	GameSettings.MapName.MINI: preload("res://scenes/mini_path.tscn")
}

const VEHICLE_SCENE := preload("res://scenes/vehicle.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_label_initialize()
	GameEvents.cone_hit.connect(_on_cone_hit)
	#GameEvents.checkpointPenalty.connect(_on_checkpoint_violation)
	#GameEvents.lapCompletion.connect(_on_lap_completion)
		
	var track_instance = _load_track()
	_connect_track_signals(track_instance)
	_spawn_vehicle(track_instance)
	
	
	
func _load_track() -> Node3D:
	# clear out any previous track (useful if you ever reload without changing scene)
	for child in track_container.get_children():
		child.queue_free()

	var scene: PackedScene = MAP_SCENES.get(
		GameSettings.map_name,
		MAP_SCENES[GameSettings.MapName.SPA]
	)
	var track_instance = scene.instantiate()
	track_container.add_child(track_instance)
	return track_instance

func _spawn_vehicle(track_instance: Node3D) -> void:
	var spawn_point: Marker3D = track_instance.get_node("SpawnPoint")

	var vehicle = VEHICLE_SCENE.instantiate()
	vehicle.global_transform = spawn_point.global_transform
	add_child(vehicle) 

func _connect_track_signals(track_instance: Node3D) -> void:
	#var signal_base: Node3D = track_instance.get_node("CheckpointManager")
	GameEvents.checkpointPenalty.connect(_on_checkpoint_violation)
	GameEvents.lapCompletion.connect(_on_lap_completion)
	
func _on_lap_completion(_meh):
	if time_elapsed == 0.0:
		last_lap = time_elapsed
	last_lap = time_elapsed - last_lap
	LapTimeLabel.text = "Last Lap: %.2f" %last_lap
	last_lap = time_elapsed
	current_lap += 1
	LapLabel.text = "Lap: %d" %current_lap
	
func _on_checkpoint_violation(amount,vehicle) -> void:
	#print("Hey I am checkpoint violation function inside score_system %.1f" % amount)
	GameSettings.penalty += amount
	PenaltyLabel.text = "Penalty\n %.1f" %GameSettings.penalty

func _on_cone_hit(amount):
	print("Recieved")
	GameSettings.penalty += amount
	PenaltyLabel.text = "Penalty >:D\n %.1f" %GameSettings.penalty
	
func _label_initialize() -> void:
	PenaltyLabel.text = "Awesome\n Driving"
	LapLabel.text = "Lap: %d" %current_lap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		time_elapsed = 0
		
	accumulator += delta
	secondAccu += delta
	if accumulator > 0.08:
		accumulated(accumulator)
		accumulator = 0.0
	if secondAccu > 0.5:
		secondCounter(secondAccu)
		secondAccu = 0.0
		
func secondCounter(_accu: float) -> void:
	SpeedLabel.text = "Speed :\n %.1f kmph" % GameSettings.speed
	AngleLabel.text = "Steer :\n %.2f rads" % GameSettings.angle
	PenaltyLabel.text = "Penalty :\n %.1f" % GameSettings.penalty
	
	
func accumulated(accu: float) -> void:
	time_elapsed += accu
	TimeLabel.text = "Time elapsed :\n %.3f s" % time_elapsed
