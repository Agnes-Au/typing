extends Area2D

const TILE_SIZE = 64
var inputs
#var has_moved = false
var input_updated = false
signal input_received(letter)
	
func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2

func _unhandled_input(event: InputEvent) -> void:
	var key
	if event.as_text() in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" and event.is_pressed() and not event.echo:
		input_received.emit()
		key = event.as_text()
		if input_updated:
			if key in inputs.keys():
				move(key)
			
func move(dir):
	position += inputs[dir] * TILE_SIZE
	input_updated = false

func set_inputs(new_inputs):
	inputs = {
		new_inputs[0]: Vector2.RIGHT,
		new_inputs[1]: Vector2.LEFT,
		new_inputs[2]: Vector2.UP,
		new_inputs[3]: Vector2.DOWN
	}
	input_updated = true
