extends Label3D
var score = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cone in get_tree().get_nodes_in_group("cones"):
		cone.cone_hit.connect(_on_cone_hit)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#score += 0.1


func _on_cone_hit(amount):
	print("recieved")
	score += amount
	set_text(str(score))
	#labelText = "{0}".format({"0":score})
	
