extends Control

@onready var ConesWalls = %ConesWalls
@onready var map_dropdown = %MapDropdown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_dropdown.clear()
	map_dropdown.add_item("Spa", GameSettings.MapName.SPA)
	map_dropdown.add_item("Ink", GameSettings.MapName.INK)
	map_dropdown.item_selected.connect(_on_map_selected)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		_on_play_button_pressed()
		
func _on_play_button_pressed() -> void:
	if ConesWalls.button_pressed == true:
		GameSettings.boundary_type = GameSettings.BoundaryType.WALLS
	elif ConesWalls.button_pressed == false:
		GameSettings.boundary_type = GameSettings.BoundaryType.CONES	
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")
		
func _on_map_selected(index: int) -> void:
	var selected_map: int = map_dropdown.get_item_id(index)
	GameSettings.map_name = selected_map as GameSettings.MapName
	print(GameSettings.map_name)
	
