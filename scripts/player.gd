extends Area2D

const TILE_SIZE = 64
var inputs
#var has_moved = false
var input_updated = false
signal input_received(letter)
signal letter_eaten(letter, dir)
	
func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2

func _unhandled_input(event: InputEvent) -> void:
	var key
	if event.is_pressed() and not event.is_echo():
		if event.as_text() in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
			input_received.emit()
			key = event.as_text()
			if input_updated:
				if key in inputs.keys():
					move(key)
		elif "Shift+" in event.as_text():
			input_received.emit()
			var eaten_letter = event.as_text().split("+")[1]
			if eaten_letter in inputs.keys():
				letter_eaten.emit(eaten_letter, inputs[eaten_letter])
			
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
