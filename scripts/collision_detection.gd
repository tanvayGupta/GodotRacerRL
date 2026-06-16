extends Area3D

@export var score_penalty := 10
var triggered = false
signal cone_hit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _body_process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	print("collided")
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		print("emitted")
		cone_hit.emit(10)
	elif body.is_in_group("cones"):
		triggered = true
		print("Emitted by cone")
		cone_hit.emit(5)
