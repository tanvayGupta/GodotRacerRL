extends Label

var time_elapsed := 0.0
var accumulator := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
