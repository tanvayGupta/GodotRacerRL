extends Control

@onready var ConesWalls = %ConesWalls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		_on_play_button_pressed()
	
	
	
func _on_play_button_pressed() -> void:
	if ConesWalls.button_pressed == true:
		GameSettings.boundary_type = GameSettings.BoundaryType.WALLS
	elif ConesWalls.button_pressed == false:
		GameSettings.boundary_type = GameSettings.BoundaryType.CONES
	get_tree().change_scene_to_file("res://screens/game.tscn")
		
	
