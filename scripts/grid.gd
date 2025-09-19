extends Node2D

const GRID_SIZE = 8
const TILE_SIZE = 64
const LETTER_COUNT = 26  # Number of letters in the alphabet
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var alphabet_arr = ALPHABET.split()
var letters = []
var eaten_letters = []
var player
var player_pos_coord: Vector2
var wordlist: Array
var score: int

@export var letter_sprite_scene: PackedScene
@export var word_label: Label
@export var score_label: Label

func build_wordlist():
	var file = FileAccess.open("res://assets/wordnik_wordlist.txt", FileAccess.READ)
	var content = file.get_as_text()
	var words = content.split("\n")
	return words

func _ready():
	wordlist = build_wordlist()
	Engine.time_scale = 1
	player = $Player
	player.input_received.connect(_on_input_received)
	player.letter_eaten.connect(_on_letter_eaten)
	player.word_discarded.connect(_on_word_discarded)
	player.word_submitted.connect(_on_word_submitted)
	player.restart.connect(_on_restart)
	generate_grid()
	position_grid()
	set_player_input()
	
func _process(_delta: float) -> void:
	$CanvasLayer/TimeProgress.value = ($EatTimer.wait_time - $EatTimer.time_left) * (100 / $EatTimer.wait_time)

func new_letter(letter):
	var letter_sprite = letter_sprite_scene.instantiate()
	$LetterContainer.add_child(letter_sprite)
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
						letters[current_coords.x][current_coords.y] = alphabet_arr[randi() % LETTER_COUNT]
	# I guess even after all this there's still a miniscule chance there are duplicates
	# BUT I DON'T CARE ANYMORE I WORKED HARD DUDE
		
func position_grid():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var letter_cell = new_letter(letters[i][j])
			letter_cell.position = Vector2(float(i) * TILE_SIZE + TILE_SIZE / 2.0, float(j) * TILE_SIZE + TILE_SIZE / 2.0) - Vector2(64*4, 64*4)
			letter_cell.name = str(letter_cell.position)

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
	var new_inputs = return_adjacent_letters_if_valid(player_pos_coord)
	player.set_inputs(new_inputs)

func is_empty_or_null(x):
	return x == "Empty" or x == null

func _on_input_received():
	player_pos_coord = Vector2((player.position.x/32-1)/2, (player.position.y/32-1)/2)
	var adj_cells = return_adjacent_letters_if_valid(player_pos_coord)
	if adj_cells.all(is_empty_or_null):
		game_over()
		return
	set_player_input()
	
func _on_letter_eaten(letter, dir):
	player_pos_coord = Vector2((player.position.x/32-1)/2, (player.position.y/32-1)/2)
	var new_empty_cell_coord = player_pos_coord + dir
	letters[new_empty_cell_coord.x][new_empty_cell_coord.y] = "Empty"
	$LetterContainer.get_child(8*new_empty_cell_coord.x + new_empty_cell_coord.y).play("Empty")
	eaten_letters.append(letter)
	word_label.text = "".join(eaten_letters)
	$EatTimer.start()

func _on_word_discarded():
	print("discarded ", "".join(eaten_letters))
	eaten_letters = []
	word_label.text = ""

func _on_word_submitted():
	var word_submitted = "".join(eaten_letters)
	if word_submitted.length() < 3:
		print("Not enough letters. Try again.")
		return
	if word_submitted.to_lower() not in wordlist:
		print(word_submitted, " is not a valid word. Try again.")
		return

	print(word_submitted, " is a valid word. Good job!")
	score += word_submitted.length() * 10
	score_label.text = str(score)
	word_label.text = ""
	eaten_letters = []

func _on_restart():
	get_tree().reload_current_scene()

func game_over():
	Engine.time_scale = 0
	word_label.text = "GAME OVER"
	word_label.add_theme_color_override("font_color", Color("ff0000"))

func _on_eat_timer_timeout() -> void:
	game_over()
