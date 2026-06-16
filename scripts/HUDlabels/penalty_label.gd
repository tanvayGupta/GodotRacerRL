extends Label
var score = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cone in get_tree().get_nodes_in_group("cones"):
		cone.cone_hit.connect(_on_cone_hit)
	
	text = "Awesome\n Driving"
	
func _on_cone_hit(amount):
	print("Recieved")
	score += amount
	text = "Penalty >:D\n %.1f" %score
