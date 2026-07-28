extends Label

var start_position: Vector2
var time := 0.0

func _ready():
	start_position = position

func _process(delta):
	time += delta
	position.x = start_position.x + sin(time * 2.0) * 20
	position.y = start_position.y + cos(time * 50.0) * 2 * sin(time * 0.4)
	
