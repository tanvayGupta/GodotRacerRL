extends Node3D
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func cone_penalty() -> void:
	#score = score + 10
	#emit_signal("cone_hit",10)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score = score + delta
	
