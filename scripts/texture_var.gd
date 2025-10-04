extends TextureRect

@export var TEXTURE_ARR: Array[Texture]

func _ready() -> void:
	vary_texture()
	
func vary_texture() -> void:
	if TEXTURE_ARR.size() > 1:
		var texture_id: int = randi() % TEXTURE_ARR.size()
		var chosen_texture: Texture = TEXTURE_ARR[texture_id]
		texture = chosen_texture
