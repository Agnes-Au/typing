extends Node2D

const GRID_SIZE = 8
const TILE_SIZE = 64
const LETTER_COUNT = 26  # Number of letters in the alphabet
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var alphabet_arr = ALPHABET.split()

var letters = []
var player
var LETTER_SPRITE_SCENE = preload("res://scenes/Letter.tscn")

func new_letter(letter):
	var letter_sprite = LETTER_SPRITE_SCENE.instantiate()
	add_child(letter_sprite)
	letter_sprite.animation = letter
	return letter_sprite

func _ready():
	player = $Player
	generate_grid()
	position_grid()
	
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
