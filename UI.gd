extends CanvasLayer
signal change_stencil(typeId)

export (PackedScene) var stencil

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var shapeSelectBtn = $Sidebar/HBoxContainer/OptionButton
onready var colorPicker = $Sidebar/HBoxContainer/ColorPickerButton
onready var previewStencil = $Sidebar/PreviewStencil

var type
var color

# Called when the node enters the scene tree for the first time.
func _ready():
	shapeSelectBtn.add_item("Solid", 0)
	shapeSelectBtn.add_item("Square", 1)
	shapeSelectBtn.add_item("Diamond", 2)
	shapeSelectBtn.add_item("Circle", 3)
	
	colorPicker.get_picker().add_preset(Color(1,0,0)) #red
	colorPicker.get_picker().add_preset(Color(0,1,0)) #green
	colorPicker.get_picker().add_preset(Color(0,0,1)) #blue
	colorPicker.get_picker().add_preset(Color(0,0.5,0.5)) #yellow
	
	type = "solid"
	color = colorPicker.color
	$Sidebar/TextureRect.texture = previewStencil.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	previewStencil.color = color
	previewStencil.type = type
	$Sidebar/TextureRect.texture = previewStencil.get_texture()

func _on_OptionButton_item_selected(index):
	match index:
		0: type = "solid"
		1: type = "square"
		2: type = "diamond"
		3: type = "circle"

func _on_ColorPickerButton_color_changed(color):
	self.color = color
