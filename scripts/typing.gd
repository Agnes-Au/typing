extends Control

var wordlist
var current_word
var index = 0

func random_word():
	current_word = wordlist[randi_range(0, len(wordlist))]
	return current_word
	
func new_word():
		var word = random_word()
		$Word.text = word
		index = 0
		return word

func _ready():
	var file = FileAccess.open("res://assets/mit_wordlist.txt", FileAccess.READ)
	var content = file.get_as_text()
	wordlist = content.split("\n")
	$Word.text = random_word()

func _input(event):
	var key = event.as_text()
	if event is InputEventKey and event.pressed and not event.echo:
		if event.is_action_pressed("submit"):
			new_word()
			return
		
		$Key.text = key
		if index >= current_word.length()-1:
			new_word()
			return
		if current_word[index].capitalize() == key:
			$Word.text = "[color=green]" + current_word.substr(0, index+1) + "[/color]" + current_word.substr(index+1, current_word.length())
			index += 1
	
