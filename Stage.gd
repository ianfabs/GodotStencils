extends Node2D

export (PackedScene) var stencil

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_stencil_color
var new_stencil_shape

var stencils = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	stencils = $Stack.get_children()
	stencils[0].set_button($UI/Footer/Stencils)
#	for stencil in stencils: add_stencil_btn(stencil)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	$UI/Footer/Stencils/TextureButton.

func _on_ColorPickerButton_color_changed(color):
	new_stencil_color = color

func _on_OptionButton_item_selected(index):
	match index:
		0: new_stencil_shape = "square"
		1: new_stencil_shape = "diamond"
		2: new_stencil_shape = "circle"

func _on_Button_pressed():
	stencils.append(stencil.instance())

func add_stencil_btn(stencil):
	var btn : TextureButton = stencil.get_button().duplicate()
	$UI/Footer/Stencils.add_child(btn)
	btn.show()
