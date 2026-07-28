extends Node3D

@onready var track_container: Node3D = %TrackContainer

const MAP_SCENES := {
	GameSettings.MapName.SPA: preload("res://scenes/spa_path.tscn"),
	GameSettings.MapName.INK: preload("res://scenes/agent_path.tscn"),
}

func _ready() -> void:
	_load_track()

func _load_track() -> void:
	# clear out any previous track (useful if you ever reload without changing scene)
	for child in track_container.get_children():
		child.queue_free()

	var scene: PackedScene = MAP_SCENES.get(
		GameSettings.map_name,
		MAP_SCENES[GameSettings.MapName.SPA]
	)
	var track_instance = scene.instantiate()
	track_container.add_child(track_instance)
