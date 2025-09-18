extends Area2D

const TILE_SIZE = 64
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}
signal input_received(letter)
	
func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2

func _unhandled_input(event: InputEvent) -> void:
	if event.as_text() in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" and event.is_pressed() and not event.echo:
		input_received.emit()

	for dir in inputs.keys():
		if event.as_text() == dir:
			move(dir)
			
func move(dir):
	position += inputs[dir] * TILE_SIZE
	print(position)

func set_inputs(new_inputs):
	inputs = {
		new_inputs[0]: Vector2.RIGHT,
		new_inputs[1]: Vector2.LEFT,
		new_inputs[2]: Vector2.UP,
		new_inputs[3]: Vector2.DOWN
	}
