tool
extends Node2D

export (Color) var color = Color(1,0,0,1)
export (String, "square", "diamond", "circle") var type = "square" 
export (int, "small", "big") var size = 0
export (float) var side_length = 500

func vec2(x, y): return Vector2(x, y)

var rotation_angle = 50
var angle_from = 0
var angle_to = 360

func _draw():
	$Polygon2D.color = color
#	draw_circle_arc(center, radius, angle_from, angle_to, color)
#	draw_circle_arc_poly(center, radius, angle_from, angle_to, color)
#	draw_circle_arc( center, radius, angle_from, angle_to, color )
#	draw_rect(Rect2(50,50,100,100), color, true)
#	draw_square_with_cutout(cutout, color)
	draw_stencil(type)

func _ready():
	draw_stencil(type)
	update()
#	pass

func draw_stencil(stencil):
	match stencil:
		"square":
			$Polygon2D.invert_border = side_length/4
			var l = side_length/2
			var fq = side_length/4
			var lq = fq*3
			draw_hole(PoolVector2Array([
				vec2(fq,fq),vec2(lq,fq),vec2(lq,lq),vec2(fq,lq)
			]))
		"diamond":
			$Polygon2D.invert_border = side_length/7
			var f = vec2(14.35534/100, 85.35534/100)
			var fq = side_length/4
			var lq = fq*3
			var l = side_length/2
			var sq = PoolVector2Array([vec2(fq,fq),vec2(lq,fq),vec2(lq,lq),vec2(fq,lq)])
			var dm = PoolVector2Array([vec2(l,(side_length*f.x)), vec2((side_length*f.y),l), vec2(l,(side_length*f.y)), vec2((side_length*f.x),l)])
			draw_hole(dm)
		"circle":
			var nb_points = 64
			var points_arc = PoolVector2Array()
			var center = vec2(side_length/2,side_length/2)
			var inc = 100
			var radius = (center.x+inc)/2
			var d = radius*2
#			var radius = 200
#			$Polygon2D.invert_border = (radius / ((100.0+inc)/100.0))
			$Polygon2D.invert_border = (side_length-d)/2.0
#			print((radius / 1.9415))
#			print("d = ", d)
#			print("l = ", side_length)
#			print((side_length-d)/2.0)
#			print(((100.0+inc)/100.0))
#			print((radius / 1.5))
			for i in range(nb_points + 1):
				var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
				points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
			draw_hole(points_arc)

func draw_hole(holeShape: PoolVector2Array):
	$Polygon2D.polygon = holeShape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	material.set_shader_param("color", color)
	update()
	
func draw_sq_w_cutout(shape: PoolVector2Array, color):
	var colors = PoolColorArray([color])
	var square = PoolVector2Array([vec2(0,0), vec2(side_length, 0), vec2(side_length,side_length), vec2(0, side_length)])
	draw_polygon(square, colors)
	draw_polygon(shape, [Color(0,0,0,1)])
	

func dist(pt1, pt2): return sqrt(pow(pt2.x - pt1.x,2) + pow(pt2.y - pt1.y,2))

func _on_OptionButton_item_selected(index):
	match index:
		0: type = "square"
		1: type = "diamond"
		2: type = "circle"

func get_hex_code():
	var colorHex = 0x000
	if color == Color(1,0,0):
		colorHex = 0x000
	elif color == Color(0,1,0):
		colorHex = 0x010
	elif color == Color(0,0,1):
		colorHex = 0x020
		
	var shapeHex = 0x000
	if type == "square":
		shapeHex = 0x000
	elif type == "diamond":
		shapeHex = 0x100
	elif type == "circle":
		shapeHex = 0x200
	
	return shapeHex + colorHex


func _on_ColorPickerButton_color_changed(color):
	self.color = color
