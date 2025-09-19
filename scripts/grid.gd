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
		
	# this part onwards is for cleaning up adjacents and it's HORRIBLY WRITTEN.
	# please clean up if time allows

	# grabs every letter's adjacents, checks if they're identical and replace in adj_letters if not
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var adj_letters = return_adjacent_letters_if_valid(Vector2(i, j))
			var adj_coords = return_adj_coords_if_valid(Vector2(i, j))
			for adj_letter in adj_letters:
				if adj_letter != null:
					while adj_letters.count(adj_letter) > 1:
						adj_letters.erase(adj_letter)
						adj_letters.insert(adj_letters.bsearch(adj_letter), alphabet_arr[randi() % LETTER_COUNT])
	
	# replace in actual letters array
			for k in range(4):
				if adj_letters[k] != null and adj_coords[k] != null:
					var current_coords = adj_coords[k]
					letters[current_coords.x][current_coords.y] = adj_letters[k]
					
					# the above code doesn't catch all duplicates for some reason so we're doing this again
					if adj_letters.count(adj_letters[k]) > 1:
						print(adj_letters[k])
						letters[current_coords.x][current_coords.y] = alphabet_arr[randi() % LETTER_COUNT]
	# I guess even after all this there's still a miniscule chance there are duplicates
	# BUT I DON'T CARE ANYMORE I WORKED HARD DUDE
		
func position_grid():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var letter_cell = new_letter(letters[i][j])
			letter_cell.position = Vector2(float(i) * TILE_SIZE + TILE_SIZE / 2.0, float(j) * TILE_SIZE + TILE_SIZE / 2.0)

func return_adj_coords_if_valid(coord: Vector2):
	var right_coord = Vector2(coord.x+1, coord.y)
	var left_coord = Vector2(coord.x-1, coord.y)
	var up_coord = Vector2(coord.x, coord.y-1)
	var down_coord = Vector2(coord.x, coord.y+1)
	var valid_coords = []
	
	for c in [right_coord, left_coord, up_coord, down_coord]:
		if c.x < 0 or c.x >= GRID_SIZE or c.y < 0 or c.y >= GRID_SIZE:
			valid_coords.append(null)
		else:
			valid_coords.append(c)
	return valid_coords

func return_adjacent_letters_if_valid(coord: Vector2):
	var adj_letters = []
	
	for c in return_adj_coords_if_valid(coord):
		if c != null:
			adj_letters.append(letters[c.x][c.y])
		else:
			adj_letters.append(null)
	return adj_letters

func set_player_input():
	var player_pos_coord = Vector2((player.position.x/32-1)/2, (player.position.y/32-1)/2)
	var new_inputs = return_adjacent_letters_if_valid(player_pos_coord)
	player.set_inputs(new_inputs)

func _on_input_received():
	set_player_input()
	
