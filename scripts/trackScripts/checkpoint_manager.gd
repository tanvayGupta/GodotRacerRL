extends Node3D

var current_checkpoint: int = 1
var checkpoint_count: int = 0

#var totalViolations: int = 0
signal checkpointViolation
signal lapCompletion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var checkpoints = get_tree().get_nodes_in_group("Checkpoints")
	
	checkpoint_count = checkpoints.size()
	
	for checkpoint in checkpoints:
		checkpoint.checkpoint_passed.connect(_on_checkpoint_pass)

func _on_checkpoint_pass(checkpoint_id: int) -> void:
	if checkpoint_id != current_checkpoint:
		checkpointViolation.emit(40)
		#totalViolations += 1
		#if totalViolations == 3:
			#totalViolations = 0
		return
	
	current_checkpoint += 1
	
	if current_checkpoint == (checkpoint_count + 1):
		lap_complete()

func lap_complete():
	lapCompletion.emit(1)
	current_checkpoint = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
