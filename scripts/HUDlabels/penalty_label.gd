extends Label
var score = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var raceManager = %RaceManager
	
	
	self.checkpointViolation.connect(_on_checkPoint_Violation)
		
	
	
	
	

	
