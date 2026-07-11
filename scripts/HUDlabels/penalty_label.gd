extends Label
var score = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var raceManager = %RaceManager
	for cone in get_tree().get_nodes_in_group("cones"):
		cone.cone_hit.connect(_on_cone_hit)
	
	raceManager.checkpointViolation.connect(_on_checkPoint_Violation)
		
	
	
	text = "Awesome\n Driving"
	
func _on_cone_hit(amount):
	print("Recieved")
	score += amount
	text = "Penalty >:D\n %.1f" %score
	
func _on_checkPoint_Violation(amount):
	score += amount
	text = "Checkpoint Penalty >:C\n %.1f" %score
