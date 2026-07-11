extends Area3D

signal checkpoint_passed(checkpoint_id: int)

@export var checkpoint_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		checkpoint_passed.emit(checkpoint_id)
