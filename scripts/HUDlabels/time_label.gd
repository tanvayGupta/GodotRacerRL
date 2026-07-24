extends Label

var time_elapsed := 0.0
var accumulator := 0.0
var last_lap := 0.0
@onready var LapTimeLabel = %LapTimeLabel
@onready var RaceManager = %RaceManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RaceManager.lapCompletion.connect(_on_lap_completion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		time_elapsed = 0
		
	accumulator += delta
	if accumulator > 0.08:
		accumulated(accumulator)
		accumulator = 0.0
	
	
func accumulated(accu: float) -> void:
	time_elapsed += accu
	text = "Time elapsed :\n %.3f s" % time_elapsed
	
func _on_lap_completion(meh):
	var delta_lap = 0.0
	if time_elapsed == 0.0:
		last_lap = time_elapsed
	delta_lap = time_elapsed - last_lap
	last_lap = time_elapsed - delta_lap
	LapTimeLabel.text = "Last Lap: %.2f" %last_lap
