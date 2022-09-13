extends TextureButton

export (int, 10, 100) var size = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_size = Vector2(size, size)
	expand = true
	stretch_mode = TextureButton.STRETCH_SCALE

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
