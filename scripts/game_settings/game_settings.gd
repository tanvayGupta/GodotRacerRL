extends Node

enum BoundaryType {
	CONES,
	WALLS
}

enum MapName {
	SPA,
	INK,
	MINI
}

var boundary_type = BoundaryType.CONES
var map_name = MapName.INK

var penalty = 0.0
var speed = 0.0
var angle = 0.0
