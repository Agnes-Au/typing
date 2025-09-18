extends Node2D

const GRID_SIZE = 8
const TILE_SIZE = 64
const LETTER_COUNT = 26  # Number of letters in the alphabet
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var alphabet_arr = ALPHABET.split()

var letters = []
var player
var LETTER_SPRITE_SCENE = preload("res://scenes/Letter.tscn")


func _ready():
	player = $Player
	player.input_received.connect(_on_input_received)
	generate_grid()
	position_grid()
	set_player_input()

func new_letter(letter):
	var letter_sprite = LETTER_SPRITE_SCENE.instantiate()
	add_child(letter_sprite)
	letter_sprite.animation = letter
	return letter_sprite
	
func generate_grid():
	for i in range(GRID_SIZE):
		var row = []
		for j in range(GRID_SIZE):
			var random_letter_index = randi() % LETTER_COUNT  # Random index for A-Z
			row.append(alphabet_arr[random_letter_index])
		letters.append(row)
		
func position_grid():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var letter_cell = new_letter(letters[i][j])
			@warning_ignore("integer_division")
			letter_cell.position = Vector2(i * TILE_SIZE + TILE_SIZE/2, j * TILE_SIZE + TILE_SIZE/2)

func set_player_input():
	var player_pos_coord = Vector2((player.position.x/32-1)/2, (player.position.y/32-1)/2)
	var player_x = player_pos_coord.x
	var player_y = player_pos_coord.y
	var right_coord = Vector2(player_x+1, player_y)
	var left_coord = Vector2(player_x-1, player_y)
	var up_coord = Vector2(player_x, player_y-1)
	var down_coord = Vector2(player_x, player_y+1)
	var new_inputs = []
	
	for coord in [right_coord, left_coord, up_coord, down_coord]:
		if coord.x < 0 or coord.x >= 8 or coord.y < 0 or coord.y >= 8:
			new_inputs.append(null)
		else:
			new_inputs.append(letters[coord.x][coord.y])
			
	player.set_inputs(new_inputs)

func _on_input_received():
	set_player_input()
	
