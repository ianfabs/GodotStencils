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
	for stencil in stencils:
		var txRect = TextureRect.new()
		txRect.texture = stencil.get_texture()
		txRect.rect_size.x = 50
		txRect.rect_size.y = 50
		txRect.expand = true
		txRect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		$UI/Footer/Stencils.add_child(txRect)
#	for stencil in stencils: add_stencil_btn(stencil)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	$UI/Footer/Stencils/TextureButton.

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
