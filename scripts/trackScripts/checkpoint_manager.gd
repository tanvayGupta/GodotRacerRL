extends Node3D

var current_checkpoint: int = 1
var checkpoint_count: int = 0

var humanMode = PlayerSettings.humanMode



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var checkpoints = get_tree().get_nodes_in_group("Checkpoints")
	
	checkpoint_count = checkpoints.size()
	
	for checkpoint in checkpoints:
		if humanMode:
			checkpoint.checkpoint_passed.connect(_on_checkpoint_pass_human)
		else:
			checkpoint.checkpoint_passed.connect(_on_checkpoint_passed_ai)
			
func _on_checkpoint_passed_ai(checkpoint_id: int, vehicle: VehicleBody3D) -> void:
	#current_checkpoint += 1
	if checkpoint_id != current_checkpoint:
		GameEvents.checkpointPenalty.emit(2.0, vehicle)
		return

	current_checkpoint += 1
	GameEvents.checkpointPassed.emit(vehicle)

	if current_checkpoint == (checkpoint_count + 1):
		lap_complete()
	

func _on_checkpoint_pass_human(checkpoint_id: int, _vehicle: VehicleBody3D) -> void:
	if checkpoint_id != current_checkpoint:
		#print("I work")
		#I think i should emit the penalty directly
		GameEvents.checkpointPenalty.emit(40, _vehicle)
		return
	
	GameEvents.checkpointPenalty.emit(0, _vehicle)
	current_checkpoint += 1
	
	if current_checkpoint == (checkpoint_count + 1):
		lap_complete()

func lap_complete():
	GameEvents.lapCompletion.emit(1)
	current_checkpoint = 1
	

func _process(_delta: float) -> void:
	pass
