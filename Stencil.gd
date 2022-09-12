tool
extends Node2D

export (int, "square", "diamond", "circle", "solid", "star") var stencil_type = 0 setget set_stencil_type
export (Color) var color setget set_color

var border = 64
var offset = 64

func set_stencil_type(w):
	print('type changed')
	property_list_changed_notify()
	if w == 0:
		polygon = basePolygon
		border = 64
	elif w == 1:
		polygon = diamondPolygon
		border = 32
	stencil_type = w
	$Square.set_polygon(polygon)
	$Square.invert_border = border

func set_color(w):
	property_list_changed_notify()
	color = w
	$Square.color = color

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var solid = $Base
onready var square = $Square

var basePolygon = PoolVector2Array([Vector2(0,0),Vector2(128,0),Vector2(128,128),Vector2(0,128)])
var diamondPolygon = rotate_shape(basePolygon, Vector2(128,128), 45)

var polygon = basePolygon

# Called when the node enters the scene tree for the first time.
func _ready():
	print('Square', basePolygon)
	print('Diamond', diamondPolygon)
	$Base.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Square.polygon != polygon:
		print('type changed')
		$Square.polygon = polygon

func rotate_shape(shape: PoolVector2Array, size : Vector2, angle : float) -> PoolVector2Array:
	var ang = deg2rad(angle)
	var center = size / 2
	var newShape = PoolVector2Array()
	for point in shape:
		var d = point - center
		var a = atan2(d.y, d.x)
		var dist = sqrt(pow(d.x,2) + pow(d.y,2))
		var a2 = a + ang
		var d2 = Vector2(cos(a2)*dist,sin(a2)*dist)
		newShape.append(d2)
	return newShape
	


func _on_UI_change_stencil(typeId):
	set_stencil_type(typeId)
