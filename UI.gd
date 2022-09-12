extends CanvasLayer
signal change_stencil(typeId)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var shapeSelectBtn = $Sidebar/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	shapeSelectBtn.add_item("Square", 0)
	shapeSelectBtn.add_item("Diamond", 1)
	shapeSelectBtn.add_item("Circle", 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
