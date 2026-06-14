extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)
	set_collision_mask_value(2,true)
	set_collision_priority(1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
