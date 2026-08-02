extends Area3D

signal checkpoint_passed(checkpoint_id: int, vehicle: VehicleBody3D)

@export var checkpoint_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)



func _on_body_entered(body: Node3D) -> void:
	if body is VehicleBody3D:
		checkpoint_passed.emit(checkpoint_id, body)
