extends Node2D

const GRID_SIZE = 8
const TILE_SIZE = 64
const LETTER_COUNT = 26  # Number of letters in the alphabet

var letters = []
var player
var LETTER_SPRITE_SCENE = preload("res://scenes/Letter.tscn")

func _ready():
	player = $Player
	generate_grid()
	var letter_sprite = LETTER_SPRITE_SCENE.instantiate()
	add_child(letter_sprite)
	letter_sprite.position = player.position
	letter_sprite.animation = "D"

func generate_grid():
	for i in range(GRID_SIZE):
		var row = []
		for j in range(GRID_SIZE):
			var random_letter_index = randi() % LETTER_COUNT  # Random index for A-Z
			row.append(random_letter_index)
		letters.append(row)
