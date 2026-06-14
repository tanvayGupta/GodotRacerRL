extends OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	light_energy = 0
	if Input.is_action_pressed("brake"):
		light_energy = 2.5
	pass
