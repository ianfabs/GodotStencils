extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	connect("gui_input", self, "_click_to_del")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(2):
		print('delete')
		queue_free()

#func _click_to_del(ev):
#	if ev is InputEventMouseButton:
#		print('delete')
#		queue_free()
#	else:
#		print('hover')
